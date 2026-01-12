from pydantic import BaseModel
from datetime import datetime

class ExploreCreate(BaseModel):
    title: str
    image_url: str
    description: str

class ExploreOut(ExploreCreate):
    id: int
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True
