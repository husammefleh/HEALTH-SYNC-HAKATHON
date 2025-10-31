# Hedera Writer Microservice (Node.js)

Node.js microservice that submits payloads to a Hedera Consensus Service topic and exposes a lightweight API to read back the latest messages from the Hedera Mirror Node.

## Requirements

- Node.js 18+ recommended
- Hedera account credentials with topic write permissions

## Setup

```bash
npm ci
copy .env.example .env
npm start
```

Update the new `.env` file with your Hedera operator credentials, target topic ID, and optional mirror node override before starting the service.

> ⚠️ Never commit your `.env` file or any private keys to version control.

## API

- `POST /submit` – body `{ "payload": ... , "topicId": "optional override" }`; returns Hedera transaction details.
- `GET /messages` – optional `topicId` query parameter to override the default; returns the five most recent messages pulled from the mirror node.

## Verifying Messages on the Mirror Node

After submitting a payload, confirm it reached Hedera by calling the public mirror node API. Replace `<topicId>` with the topic you are using:

```bash
curl "https://testnet.mirrornode.hedera.com/api/v1/topics/<topicId>/messages?limit=5&order=desc"
```

The response will include the consensus timestamps, sequence numbers, and encoded message bodies that match what the microservice returns from `/messages`.
