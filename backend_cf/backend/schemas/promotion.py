from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List
from schemas.promotion_product import PromotionProductOut

class PromotionOut(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    discount_percent: Optional[int] = None
    discount_amount: Optional[float] = None
    start_date: datetime
    end_date: datetime
    promotion_products: List[PromotionProductOut]

    class Config:
        from_attributes = True