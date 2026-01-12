from pydantic import BaseModel, EmailStr
from typing import Optional

class UserBase(BaseModel):
    email: EmailStr

class UserCreate(UserBase):
    password: str

# Schema cho Login Request
class UserLogin(UserBase):
    password: str

# Schema cho Token Response
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: int
    email: EmailStr

# Schema trả về cho API
class User(UserBase):
    id: int
    role: str
    
    class Config:
        from_attributes = True