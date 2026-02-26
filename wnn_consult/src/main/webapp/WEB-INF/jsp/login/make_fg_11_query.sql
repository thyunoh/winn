ELSEIF make_fg = '11' THEN
    -- 검사료 현황
    -- ★ 최적화: HOSP_CD <> hosp_cd 대신, 전체(DATE_YM 인덱스) 1회 스캔 후
    --   조건부 집계로 현재병원/전체를 동시 계산
    --   다른병원 평균 = (전체합계 - 현재병원합계) / (전체병원수 - 1)

    SELECT hosp_cd
         , jobyymm
         , make_fg
         , t.typecode
         , COALESCE(sub.totcount, 0)
         , COALESCE(sub.t_amount, 0)
      FROM (
           SELECT 'A' AS typecode UNION ALL
           SELECT 'B' UNION ALL
           SELECT 'C' UNION ALL
           SELECT 'D' UNION ALL
           SELECT 'E' UNION ALL
           SELECT 'F' UNION ALL
           SELECT 'H' UNION ALL
           SELECT 'I' UNION ALL
           SELECT 'J' UNION ALL
           SELECT 'K' UNION ALL
           SELECT 'L' UNION ALL
           SELECT 'M'
    ) t
    LEFT JOIN (

        -- ============================================
        -- A + H: 청구금액 (1회 스캔으로 현재병원 + 다른병원평균 동시 계산)
        -- ============================================
         SELECT 'A' AS typecode
              , 0   AS totcount
              , SUM(CASE WHEN cm.HOSP_CD = hosp_cd
                    THEN COALESCE(mm.CLAIM_AMT, 0) + COALESCE(mm.VET_AMT, 0)
                       + COALESCE(mm.NON100_VET, 0) + COALESCE(mm.NON100_CLAIM, 0)
                    ELSE 0 END) AS t_amount
           FROM TBL_CHUNG_MST  cm
           JOIN TBL_MYOUNG_MST mm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
          WHERE cm.DATE_YM = jobyymm
            AND NOT EXISTS ( SELECT 1
                               FROM TBL_SPECODE_MST tsm
                              WHERE tsm.HOSP_CD   = mm.HOSP_CD
                                AND tsm.CLAIM_NO  = mm.CLAIM_NO
                                AND tsm.BILL_SEQ  = mm.BILL_SEQ
                                AND tsm.SPEC_TYPE = 'JS008' )
            AND COALESCE(mm.DELYN,'') = ''

          UNION ALL

         SELECT 'H' AS typecode
              , 0   AS totcount
              , ( SUM(COALESCE(mm.CLAIM_AMT, 0) + COALESCE(mm.VET_AMT, 0)
                    + COALESCE(mm.NON100_VET, 0) + COALESCE(mm.NON100_CLAIM, 0))
                - SUM(CASE WHEN cm.HOSP_CD = hosp_cd
                      THEN COALESCE(mm.CLAIM_AMT, 0) + COALESCE(mm.VET_AMT, 0)
                         + COALESCE(mm.NON100_VET, 0) + COALESCE(mm.NON100_CLAIM, 0)
                      ELSE 0 END)
                ) / NULLIF(COUNT(DISTINCT CASE WHEN cm.HOSP_CD <> hosp_cd THEN cm.HOSP_CD END), 0)
                AS t_amount
           FROM TBL_CHUNG_MST  cm
           JOIN TBL_MYOUNG_MST mm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
          WHERE cm.DATE_YM = jobyymm
            AND NOT EXISTS ( SELECT 1
                               FROM TBL_SPECODE_MST tsm
                              WHERE tsm.HOSP_CD   = mm.HOSP_CD
                                AND tsm.CLAIM_NO  = mm.CLAIM_NO
                                AND tsm.BILL_SEQ  = mm.BILL_SEQ
                                AND tsm.SPEC_TYPE = 'JS008' )
            AND COALESCE(mm.DELYN,'') = ''

        -- ============================================
        -- B,C + I,J: EDI_CODE 기준 (1회 스캔)
        -- ============================================
          UNION ALL

         SELECT CASE WHEN RIGHT(jm.EDI_CODE,1) = 'Z' THEN 'C' ELSE 'B' END AS typecode
              , 0
              , SUM(CASE WHEN cm.HOSP_CD = hosp_cd THEN COALESCE(jm.AMOUNT, 0) ELSE 0 END)
           FROM TBL_CHUNG_MST  cm
           JOIN TBL_MYOUNG_MST mm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
           JOIN TBL_JINORD_MST jm ON mm.HOSP_CD = jm.HOSP_CD AND mm.CLAIM_NO = jm.CLAIM_NO AND mm.BILL_SEQ = jm.BILL_SEQ
          WHERE cm.DATE_YM = jobyymm
            AND mm.MFORM_NO NOT IN ('K020','K030','C110','M312','M313')
            AND (jm.ITEM_NO = '09' AND jm.CODE_NO IN ('01','02','03')
                 OR
                 jm.ITEM_NO = 'L'  AND jm.CODE_NO IN ('89'))
            AND COALESCE(jm.AMOUNT,0) > 0
            AND NOT EXISTS ( SELECT 1
                               FROM TBL_SPECODE_MST tsm
                              WHERE tsm.HOSP_CD   = mm.HOSP_CD
                                AND tsm.CLAIM_NO  = mm.CLAIM_NO
                                AND tsm.BILL_SEQ  = mm.BILL_SEQ
                                AND tsm.SPEC_TYPE = 'JS008' )
            AND COALESCE(mm.DELYN,'') = ''
          GROUP BY CASE WHEN RIGHT(jm.EDI_CODE,1) = 'Z' THEN 'C' ELSE 'B' END

          UNION ALL

         SELECT CASE WHEN RIGHT(jm.EDI_CODE,1) = 'Z' THEN 'J' ELSE 'I' END AS typecode
              , 0
              , ( SUM(COALESCE(jm.AMOUNT, 0))
                - SUM(CASE WHEN cm.HOSP_CD = hosp_cd THEN COALESCE(jm.AMOUNT, 0) ELSE 0 END)
                ) / NULLIF(COUNT(DISTINCT CASE WHEN cm.HOSP_CD <> hosp_cd THEN cm.HOSP_CD END), 0)
           FROM TBL_CHUNG_MST  cm
           JOIN TBL_MYOUNG_MST mm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
           JOIN TBL_JINORD_MST jm ON mm.HOSP_CD = jm.HOSP_CD AND mm.CLAIM_NO = jm.CLAIM_NO AND mm.BILL_SEQ = jm.BILL_SEQ
          WHERE cm.DATE_YM = jobyymm
            AND mm.MFORM_NO NOT IN ('K020','K030','C110','M312','M313')
            AND (jm.ITEM_NO = '09' AND jm.CODE_NO IN ('01','02','03')
                 OR
                 jm.ITEM_NO = 'L'  AND jm.CODE_NO IN ('89'))
            AND COALESCE(jm.AMOUNT,0) > 0
            AND NOT EXISTS ( SELECT 1
                               FROM TBL_SPECODE_MST tsm
                              WHERE tsm.HOSP_CD   = mm.HOSP_CD
                                AND tsm.CLAIM_NO  = mm.CLAIM_NO
                                AND tsm.BILL_SEQ  = mm.BILL_SEQ
                                AND tsm.SPEC_TYPE = 'JS008' )
            AND COALESCE(mm.DELYN,'') = ''
          GROUP BY CASE WHEN RIGHT(jm.EDI_CODE,1) = 'Z' THEN 'J' ELSE 'I' END

        -- ============================================
        -- D + K: 건수 합계 (1회 스캔)
        -- ============================================
          UNION ALL

         SELECT 'D' AS typecode
              , 0
              , SUM(CASE WHEN cm.HOSP_CD = hosp_cd THEN COALESCE(jm.AMOUNT, 0) ELSE 0 END)
           FROM TBL_CHUNG_MST  cm
           JOIN TBL_MYOUNG_MST mm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
           JOIN TBL_JINORD_MST jm ON mm.HOSP_CD = jm.HOSP_CD AND mm.CLAIM_NO = jm.CLAIM_NO AND mm.BILL_SEQ = jm.BILL_SEQ
          WHERE cm.DATE_YM = jobyymm
            AND mm.MFORM_NO NOT IN ('K020','K030','C110','M312','M313')
            AND (jm.ITEM_NO = '09' AND jm.CODE_NO IN ('01','02','03')
                 OR
                 jm.ITEM_NO = 'L'  AND jm.CODE_NO IN ('89'))
            AND NOT EXISTS ( SELECT 1
                               FROM TBL_SPECODE_MST tsm
                              WHERE tsm.HOSP_CD   = mm.HOSP_CD
                                AND tsm.CLAIM_NO  = mm.CLAIM_NO
                                AND tsm.BILL_SEQ  = mm.BILL_SEQ
                                AND tsm.SPEC_TYPE = 'JS008' )
            AND COALESCE(mm.DELYN,'') = ''

          UNION ALL

         SELECT 'K' AS typecode
              , 0
              , ( SUM(COALESCE(jm.AMOUNT, 0))
                - SUM(CASE WHEN cm.HOSP_CD = hosp_cd THEN COALESCE(jm.AMOUNT, 0) ELSE 0 END)
                ) / NULLIF(COUNT(DISTINCT CASE WHEN cm.HOSP_CD <> hosp_cd THEN cm.HOSP_CD END), 0)
           FROM TBL_CHUNG_MST  cm
           JOIN TBL_MYOUNG_MST mm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
           JOIN TBL_JINORD_MST jm ON mm.HOSP_CD = jm.HOSP_CD AND mm.CLAIM_NO = jm.CLAIM_NO AND mm.BILL_SEQ = jm.BILL_SEQ
          WHERE cm.DATE_YM = jobyymm
            AND mm.MFORM_NO NOT IN ('K020','K030','C110','M312','M313')
            AND (jm.ITEM_NO = '09' AND jm.CODE_NO IN ('01','02','03')
                 OR
                 jm.ITEM_NO = 'L'  AND jm.CODE_NO IN ('89'))
            AND NOT EXISTS ( SELECT 1
                               FROM TBL_SPECODE_MST tsm
                              WHERE tsm.HOSP_CD   = mm.HOSP_CD
                                AND tsm.CLAIM_NO  = mm.CLAIM_NO
                                AND tsm.BILL_SEQ  = mm.BILL_SEQ
                                AND tsm.SPEC_TYPE = 'JS008' )
            AND COALESCE(mm.DELYN,'') = ''

        -- ============================================
        -- E,F + L,M: ITEM_NO 기준 (1회 스캔)
        -- ============================================
          UNION ALL

         SELECT CASE WHEN jm.ITEM_NO = 'L' THEN 'E' ELSE 'F' END AS typecode
              , 0
              , SUM(CASE WHEN cm.HOSP_CD = hosp_cd THEN COALESCE(jm.AMOUNT, 0) ELSE 0 END)
           FROM TBL_CHUNG_MST  cm
           JOIN TBL_MYOUNG_MST mm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
           JOIN TBL_JINORD_MST jm ON mm.HOSP_CD = jm.HOSP_CD AND mm.CLAIM_NO = jm.CLAIM_NO AND mm.BILL_SEQ = jm.BILL_SEQ
          WHERE cm.DATE_YM = jobyymm
            AND mm.MFORM_NO NOT IN ('K020','K030','C110','M312','M313')
            AND (jm.ITEM_NO = '09' AND jm.CODE_NO IN ('01','02','03')
                 OR
                 jm.ITEM_NO = 'L'  AND jm.CODE_NO IN ('89'))
            AND COALESCE(jm.AMOUNT,0) > 0
            AND NOT EXISTS ( SELECT 1
                               FROM TBL_SPECODE_MST tsm
                              WHERE tsm.HOSP_CD   = mm.HOSP_CD
                                AND tsm.CLAIM_NO  = mm.CLAIM_NO
                                AND tsm.BILL_SEQ  = mm.BILL_SEQ
                                AND tsm.SPEC_TYPE = 'JS008' )
            AND COALESCE(mm.DELYN,'') = ''
          GROUP BY CASE WHEN jm.ITEM_NO = 'L' THEN 'E' ELSE 'F' END

          UNION ALL

         SELECT CASE WHEN jm.ITEM_NO = 'L' THEN 'L' ELSE 'M' END AS typecode
              , 0
              , ( SUM(COALESCE(jm.AMOUNT, 0))
                - SUM(CASE WHEN cm.HOSP_CD = hosp_cd THEN COALESCE(jm.AMOUNT, 0) ELSE 0 END)
                ) / NULLIF(COUNT(DISTINCT CASE WHEN cm.HOSP_CD <> hosp_cd THEN cm.HOSP_CD END), 0)
           FROM TBL_CHUNG_MST  cm
           JOIN TBL_MYOUNG_MST mm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
           JOIN TBL_JINORD_MST jm ON mm.HOSP_CD = jm.HOSP_CD AND mm.CLAIM_NO = jm.CLAIM_NO AND mm.BILL_SEQ = jm.BILL_SEQ
          WHERE cm.DATE_YM = jobyymm
            AND mm.MFORM_NO NOT IN ('K020','K030','C110','M312','M313')
            AND (jm.ITEM_NO = '09' AND jm.CODE_NO IN ('01','02','03')
                 OR
                 jm.ITEM_NO = 'L'  AND jm.CODE_NO IN ('89'))
            AND COALESCE(jm.AMOUNT,0) > 0
            AND NOT EXISTS ( SELECT 1
                               FROM TBL_SPECODE_MST tsm
                              WHERE tsm.HOSP_CD   = mm.HOSP_CD
                                AND tsm.CLAIM_NO  = mm.CLAIM_NO
                                AND tsm.BILL_SEQ  = mm.BILL_SEQ
                                AND tsm.SPEC_TYPE = 'JS008' )
            AND COALESCE(mm.DELYN,'') = ''
          GROUP BY CASE WHEN jm.ITEM_NO = 'L' THEN 'L' ELSE 'M' END

    ) sub ON t.typecode = sub.typecode;
