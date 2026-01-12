from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class OrderItemBase(BaseModel):
    product_id: int
    quantity: int
    price: float
    size: Optional[str] = None
    ice: Optional[str] = None
    sugar: Optional[str] = None
    toppings: Optional[List[str]] = []
    note: Optional[str] = None

class OrderItemCreate(OrderItemBase):
    pass

class OrderItemResponse(OrderItemBase):
    id: int
    class Config:
        from_attributes = True

class OrderResponse(BaseModel):
    id: int
    user_id: int
    total_price: float
    status: str
    created_at: datetime
    items: List[OrderItemResponse]

    class Config:
        from_attributes = True



class CartItemUpdate(BaseModel):
    quantity: Optional[int] = None
    size: Optional[str] = None
    ice: Optional[str] = None
    sugar: Optional[str] = None
    toppings: Optional[List[str]] = None
    note: Optional[str] = None