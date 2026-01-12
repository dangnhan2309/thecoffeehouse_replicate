from pydantic import BaseModel
from typing import Optional
from datetime import time, datetime

class StoreResponse(BaseModel):
    id: int
    code: str
    name: str
    address: str

    city: Optional[str]
    district: Optional[str]

    latitude: Optional[float]
    longitude: Optional[float]

    open_time: Optional[time]
    close_time: Optional[time]

    phone: Optional[str]
    image_url: Optional[str]

    created_at: datetime

    class Config:
        from_attributes = True
