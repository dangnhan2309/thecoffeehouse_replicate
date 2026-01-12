from pydantic import BaseModel
from datetime import datetime

class BannerBase(BaseModel):
    image_url: str
    sort_order: int = 0

class BannerCreate(BannerBase):
    pass

class BannerOut(BannerBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True
