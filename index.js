"use strict";

const express = require("express");
const axios = require("axios");
const {
  Client,
  TopicId,
  TopicMessageSubmitTransaction,
} = require("@hashgraph/sdk");

require("dotenv").config();

const PORT = Number(process.env.PORT) || 8081;
const hederaNetwork =
  process.env.HEDERA_NETWORK || process.env.NETWORK || null;
const operatorId =
  process.env.OPERATOR_ID || process.env.HEDERA_ACCOUNT_ID || null;
const operatorKey =
  process.env.OPERATOR_KEY || process.env.HEDERA_PRIVATE_KEY || null;
const defaultTopicId =
  process.env.TARGET_TOPIC_ID || process.env.TOPIC_ID || null;
const mirrorNodeBaseUrl =
  process.env.MIRROR_NODE_BASE_URL ||
  (hederaNetwork
    ? `https://${hederaNetwork}.mirrornode.hedera.com`
    : null);

const missingEnv = [];

if (!hederaNetwork) {
  missingEnv.push("HEDERA_NETWORK");
}

if (!operatorId) {
  missingEnv.push("OPERATOR_ID");
}

if (!operatorKey) {
  missingEnv.push("OPERATOR_KEY");
}

if (!mirrorNodeBaseUrl) {
  missingEnv.push("MIRROR_NODE_BASE_URL");
}

if (missingEnv.length > 0) {
  console.error(
    `Missing required environment variables: ${missingEnv.join(", ")}`,
  );
  process.exit(1);
}

if (!process.env.OPERATOR_ID && process.env.HEDERA_ACCOUNT_ID) {
  console.warn(
    "Using legacy HEDERA_ACCOUNT_ID environment variable. Please rename it to OPERATOR_ID.",
  );
}

if (!process.env.OPERATOR_KEY && process.env.HEDERA_PRIVATE_KEY) {
  console.warn(
    "Using legacy HEDERA_PRIVATE_KEY environment variable. Please rename it to OPERATOR_KEY.",
  );
}

if (!process.env.TARGET_TOPIC_ID && process.env.TOPIC_ID) {
  console.warn(
    "Using legacy TOPIC_ID environment variable. Please rename it to TARGET_TOPIC_ID.",
  );
}

let client;

try {
  client = Client.forName(hederaNetwork).setOperator(
    operatorId,
    operatorKey,
  );
  console.log(
    `Hedera client configured for ${hederaNetwork} with operator ${operatorId}`,
  );
} catch (error) {
  console.error("Failed to configure Hedera client:", error);
  process.exit(1);
}

const app = express();
app.use(express.json());

app.get("/", (_req, res) => {
  res.json({ status: "ok", network: hederaNetwork });
});

app.post("/submit", async (req, res) => {
  const { payload, topicId } = req.body || {};
  const resolvedTopicId = topicId || defaultTopicId;

  if (payload === undefined) {
    console.warn("POST /submit called without payload");
    return res.status(400).json({ error: "payload is required" });
  }

  if (!resolvedTopicId) {
    console.warn("POST /submit called without a topic ID");
    return res.status(500).json({
      error:
        "No topic ID configured. Set TARGET_TOPIC_ID env var or provide topicId in the request body.",
    });
  }

  try {
    const message =
      typeof payload === "string" ? payload : JSON.stringify(payload);

    const transaction = await new TopicMessageSubmitTransaction()
      .setTopicId(TopicId.fromString(resolvedTopicId))
      .setMessage(message)
      .execute(client);

    const receipt = await transaction.getReceipt(client);
    const transactionId = transaction.transactionId.toString();

    console.log(
      `Message submitted to topic ${resolvedTopicId} with transaction ${transactionId}`,
    );

    return res.json({
      topicId: resolvedTopicId,
      transactionId,
      status: receipt.status.toString(),
    });
  } catch (error) {
    console.error("Failed to submit message to Hedera:", error);
    return res
      .status(502)
      .json({ error: "Failed to submit message to Hedera." });
  }
});

app.get("/messages", async (req, res) => {
  const resolvedTopicId = req.query.topicId || defaultTopicId;

  if (!resolvedTopicId) {
    console.warn("GET /messages requested without a topic ID");
    return res.status(500).json({
      error:
        "No topic ID configured. Set TARGET_TOPIC_ID env var or supply topicId as a query parameter.",
    });
  }

  try {
    const url = `${mirrorNodeBaseUrl}/api/v1/topics/${resolvedTopicId}/messages?limit=5&order=desc`;
    const { data } = await axios.get(url, { timeout: 10000 });
    const messages = Array.isArray(data.messages)
      ? data.messages.map((message) => {
          let decoded = null;

          if (message.message) {
            try {
              decoded = Buffer.from(message.message, "base64").toString(
                "utf8",
              );
            } catch (decodeError) {
              console.warn(
                `Unable to decode message for sequence ${message.sequence_number}:`,
                decodeError,
              );
            }
          }

          return {
            consensusTimestamp: message.consensus_timestamp,
            runningHash: message.running_hash,
            sequenceNumber: message.sequence_number,
            message: decoded,
          };
        })
      : [];

    return res.json({
      topicId: resolvedTopicId,
      count: messages.length,
      messages,
    });
  } catch (error) {
    const details = error.response?.data || error.message;
    console.error("Failed to fetch messages from mirror node:", details);
    return res.status(502).json({
      error: "Failed to fetch messages from mirror node.",
    });
  }
});

app.use((err, _req, res, _next) => {
  console.error("Unhandled error in request pipeline:", err);
  res.status(500).json({ error: "Unexpected server error." });
});

app.listen(PORT, () => {
  console.log(`Hedera Writer API listening on port ${PORT}`);
});

process.on("unhandledRejection", (reason) => {
  console.error("Unhandled promise rejection:", reason);
});

process.on("uncaughtException", (error) => {
  console.error("Uncaught exception:", error);
});
