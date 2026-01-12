from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.sql import func
from database import Base

class Banner(Base):
    __tablename__ = "banners"

    id = Column(Integer, primary_key=True, index=True)
    image_url = Column(String(255), nullable=False)
    sort_order = Column(Integer, default=0)
    created_at = Column(DateTime, server_default=func.now())
