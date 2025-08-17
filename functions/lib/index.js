import { onRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
export const healthLiveness = onRequest({ region: "europe-west1" }, (req, res) => {
    res.status(200).json({ ok: true, ts: Date.now() });
});
export const hello = onRequest({ region: "europe-west1" }, (req, res) => {
    logger.info("hello called");
    res.status(200).send("hello");
});
