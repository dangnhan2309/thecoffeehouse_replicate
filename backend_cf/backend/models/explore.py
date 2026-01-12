from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime
from sqlalchemy.sql import func
from database import Base

class ExploreTopic(Base):
    __tablename__ = "explore_topics"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(150), nullable=False)
    image_url = Column(String(255), nullable=False)
    description = Column(Text, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, server_default=func.now())
