from pydantic import BaseModel
from typing import List

class OrderDetailCreate(BaseModel):
    product_id: int
    quantity: int
    price: float

class OrderCreate(BaseModel):
    items: List[OrderDetailCreate]

class OrderDetailResponse(BaseModel):
    product_id: int
    quantity: int
    price: float

    class Config:
        from_attributes = True

class OrderResponse(BaseModel):
    id: int
    total_price: float
    status: str
    details: List[OrderDetailResponse]

    class Config:
        from_attributes = True
