from pydantic import BaseModel

class CollectionProductBase(BaseModel):
    collection_id: int
    product_id: int
    sort_order: int = 0

class CollectionProductCreate(CollectionProductBase):
    pass

class CollectionProductOut(CollectionProductBase):
    class Config:
        from_attributes = True
