-- =====================================================================
-- Bronze · POS (point of sale)
-- Raw records exactly as delivered. Every column is a string; nothing is corrected.
-- =====================================================================

CREATE OR REFRESH STREAMING TABLE bronze_sales_lines
COMMENT 'Raw POS sales lines as delivered by the point-of-sale system: one row per item sold or returned. All columns are strings, exactly as in the source file. Use silver_sales_line for analysis.'
TBLPROPERTIES ('layer' = 'bronze', 'source_system' = 'pos')
AS SELECT
  src.*,
  current_timestamp()       AS _ingested_at,
  src._metadata.file_path   AS _source_file
FROM STREAM read_files(
  '${landing_root}/pos/sales_lines/',
  format            => 'csv',
  header            => true,
  inferColumnTypes  => false
) AS src;