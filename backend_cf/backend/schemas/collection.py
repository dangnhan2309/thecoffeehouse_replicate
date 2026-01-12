from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class CollectionBase(BaseModel):
    name: str
    poster_image: str
    description: Optional[str] = None

class CollectionCreate(CollectionBase):
    pass

class CollectionOut(CollectionBase):
    id: int
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True
