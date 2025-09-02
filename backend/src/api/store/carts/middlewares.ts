import {
  authenticate,
  validateAndTransformBody,
  validateAndTransformQuery,
} from "@medusajs/framework";
import { MiddlewareRoute } from "@medusajs/medusa";
import { retrieveCartTransformQueryConfig } from "./query-config";
import {
  GetCartLineItemsBulkParams,
  StoreAddLineItemsBulk,
} from "./validators";
import { 
  StoreUpdateCartLineItem,
  StoreGetCartsCart 
} from "@medusajs/medusa/api/store/carts/validators";

export const storeCartsMiddlewares: MiddlewareRoute[] = [
  {
    method: ["POST"],
    matcher: "/store/carts/:id/line-items/bulk",
    middlewares: [
      validateAndTransformBody(StoreAddLineItemsBulk),
      validateAndTransformQuery(
        GetCartLineItemsBulkParams,
        retrieveCartTransformQueryConfig
      ),
    ],
  },
  {
    method: ["POST", "DELETE"],
    matcher: "/store/carts/:id/line-items/:line_id",
    middlewares: [
      validateAndTransformBody(StoreUpdateCartLineItem),
      validateAndTransformQuery(
        StoreGetCartsCart,
        retrieveCartTransformQueryConfig
      ),
    ],
  },
  {
    method: ["POST"],
    matcher: "/store/carts/:id/approvals",
    middlewares: [authenticate("customer", ["bearer", "session"])],
  },
];
