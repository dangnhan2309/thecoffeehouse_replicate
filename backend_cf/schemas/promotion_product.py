from pydantic import BaseModel
from schemas.product import ProductOut

class PromotionProductOut(BaseModel):
    product: ProductOut

    class Config:
        from_attributes = True