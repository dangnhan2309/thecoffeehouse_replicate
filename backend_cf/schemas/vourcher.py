from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class VoucherBase(BaseModel):
    code: str
    title: str
    description: Optional[str] = None
    discount_amount: float
    min_order_value: float
    expiry_date: datetime
    is_active: bool = True

class VoucherRead(VoucherBase):
    id: int
    class Config:
        from_attributes = True
