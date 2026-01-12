from pydantic import BaseModel

class CategoryCreate(BaseModel):
    name: str

class Category(CategoryCreate):
    id: int
    
    class Config:
        from_attributes = True