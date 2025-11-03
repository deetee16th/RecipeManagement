-- SQL Script để update độ khó từ tiếng Anh sang tiếng Việt
-- Chạy script này trong SQL Server Management Studio

USE RecipeDB;
GO

-- Update các record cũ
UPDATE Recipes
SET difficulty = 
    CASE difficulty
        WHEN 'easy' THEN N'Dễ'
        WHEN 'Easy' THEN N'Dễ'
        WHEN 'EASY' THEN N'Dễ'
        WHEN 'medium' THEN N'Trung Bình'
        WHEN 'Medium' THEN N'Trung Bình'
        WHEN 'MEDIUM' THEN N'Trung Bình'
        WHEN 'hard' THEN N'Khó'
        WHEN 'Hard' THEN N'Khó'
        WHEN 'HARD' THEN N'Khó'
        ELSE difficulty
    END
WHERE difficulty IN ('easy', 'Easy', 'EASY', 'medium', 'Medium', 'MEDIUM', 'hard', 'Hard', 'HARD');
GO

-- Kiểm tra kết quả
SELECT recipe_id, recipe_name, difficulty
FROM Recipes
ORDER BY recipe_id;
GO

