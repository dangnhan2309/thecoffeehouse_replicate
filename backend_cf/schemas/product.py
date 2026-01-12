from pydantic import BaseModel
from typing import Optional, List
class ProductCreate(BaseModel):
    name: str
    description: Optional[str] = None
    price: Optional[float] = None
    price_small: Optional[float] = None
    price_medium: Optional[float] = None
    price_large: Optional[float] = None
    image_url: Optional[str] = None
    category_id: int
    is_best_seller: Optional[bool] = False


class ProductOut(BaseModel):
    id: int
    name: str
    description: str
    price: float | None
    price_small: float | None
    price_medium: float | None
    price_large: float | None
    image_url: str | None
    category_id: int | None = None

    class Config:
        from_attributes = True

class ProductIdsRequest(BaseModel):
    ids: List[int]