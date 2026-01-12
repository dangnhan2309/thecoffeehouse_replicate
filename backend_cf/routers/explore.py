from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from models.explore import ExploreTopic
from schemas.explore import ExploreCreate, ExploreOut
from typing import List

router = APIRouter(
    prefix="/explore",
    tags=["Explore"]
)

# 🔹 Lấy danh sách explore topics
@router.get("/", response_model=List[ExploreOut])
def get_explore_topics(db: Session = Depends(get_db)):
    return (
        db.query(ExploreTopic)
        .filter(ExploreTopic.is_active == True)
        .order_by(ExploreTopic.created_at.desc())
        .all()
    )

# 🔹 Tạo explore topic mới
@router.post("/", response_model=ExploreOut)
def create_explore_topic(
    data: ExploreCreate,
    db: Session = Depends(get_db)
):
    item = ExploreTopic(**data.dict())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item
    
# 🔹 Lấy chi tiết một explore topic theo ID
@router.get("/{topic_id}/", response_model=ExploreOut)
def get_explore_topic_by_id(topic_id: int, db: Session = Depends(get_db)):
    topic = db.query(ExploreTopic).filter(
        ExploreTopic.id == topic_id,
        ExploreTopic.is_active == True
    ).first()
    
    if not topic:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Topic not found")
    
    return topic
