-- 평가를 끝냈을 때 db 업데이트

DELIMITER //

CREATE PROCEDURE UpdateEvaluationStatus
            (IN     varFK_idPARSING_DSF     Int(11),
             IN     varFK_idEstimator       Int(11),
             IN     varScore                Int(11),
             IN     varPass                 varchar(45))

checkexist: BEGIN
    -- check pass is not P or NP
    IF varPass != 'P' AND varPass != 'NP' THEN
        SELECT 'pass value is invalid'
        AS InvalidPassValueErrorMessage;
        ROLLBACK;
        LEAVE checkexist;
    END IF;

    -- check score is positive number
    IF (varScore < 0) THEN
        SELECT 'score value is invalid'
        AS InvalidScoreValueErrorMessage;
        ROLLBACK;
        LEAVE checkexist;
    END IF;

    IF EXISTS (SELECT * FROM EVALUATION
                WHERE FK_idPARSING_DSF = varFK_idPARSING_DSF
                AND FK_idEstimator = varFK_idEstimator
                AND Status = 'ongoing') THEN
            -- update evaluation status to done
            UPDATE EVALUATION
                SET     Status = 'done',
                        EndTime = NOW(),
                        Score = varScore,
                        Pass = varPass
                WHERE FK_idPARSING_DSF = varFK_idPARSING_DSF
                AND FK_idEstimator = varFK_idEstimator;
    ELSE
        -- print message
        SELECT 'evaluation does not exist'
        AS UpdateEvaluationStatusErrorMessage;
    END IF;
END
//

DELIMITER ;
