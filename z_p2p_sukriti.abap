REPORT z_p2p_alv_report.

TYPE-POOLS: slis.

TABLES: ekko, ekpo.

TYPES: BEGIN OF ty_data,
        ebeln TYPE ekko-ebeln,
        bukrs TYPE ekko-bukrs,
        lifnr TYPE ekko-lifnr,
        bedat TYPE ekko-bedat,
        matnr TYPE ekpo-matnr,
        menge TYPE ekpo-menge,
        netwr TYPE ekpo-netwr,
       END OF ty_data.

DATA: it_data TYPE TABLE OF ty_data,
      wa_data TYPE ty_data.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.

START-OF-SELECTION.

SELECT a~ebeln a~bukrs a~lifnr a~bedat
       b~matnr b~menge b~netwr
  INTO TABLE it_data
  FROM ekko AS a
  INNER JOIN ekpo AS b
  ON a~ebeln = b~ebeln.

PERFORM build_fieldcat.
PERFORM display_alv.

FORM build_fieldcat.

  PERFORM add_fieldcat USING 'EBELN' 'PO Number'.
  PERFORM add_fieldcat USING 'BUKRS' 'Company Code'.
  PERFORM add_fieldcat USING 'LIFNR' 'Vendor'.
  PERFORM add_fieldcat USING 'BEDAT' 'PO Date'.
  PERFORM add_fieldcat USING 'MATNR' 'Material'.
  PERFORM add_fieldcat USING 'MENGE' 'Quantity'.
  PERFORM add_fieldcat USING 'NETWR' 'Net Value'.

ENDFORM.

FORM add_fieldcat USING p_field p_text.
  wa_fieldcat-fieldname = p_field.
  wa_fieldcat-seltext_m = p_text.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.
ENDFORM.

FORM display_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat = it_fieldcat
    TABLES
      t_outtab    = it_data.

ENDFORM.
