from passlib.hash import argon2

def hash_password(password: str) -> str:
    """Hash password dài bao nhiêu cũng được, Unicode OK"""
    return argon2.hash(password)

def verify_password(password: str, hashed: str) -> bool:
    """Verify password"""
    return argon2.verify(password, hashed)
