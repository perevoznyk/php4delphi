object PHPExtension1: TPHPExtension1
  OldCreateOrder = False
  OnCreate = PHPExtensionCreate
  OnDestroy = PHPExtensionDestroy
  Version = '0.0'
  Functions = <
    item
      FunctionName = 'produce_page'
      Tag = 0
      Parameters = <
        item
          Name = 'Action'
          ParamType = tpString
        end>
      OnExecute = PHPExtension1Functions0Execute
    end
    item
      FunctionName = 'runquery'
      Tag = 0
      Parameters = <
        item
          Name = 'CustNo'
          ParamType = tpString
        end>
      OnExecute = PHPExtension1Functions1Execute
    end>
  ModuleName = 'borland_demo'
  Left = 192
  Top = 168
  Height = 640
  Width = 870
  object Customer: TTable
    DatabaseName = 'Phpdemo'
    SessionName = 'Session1_2'
    IndexFieldNames = 'Company'
    TableName = 'CUSTOMER.DB'
    Left = 26
    Top = 64
    object CustomerCustNo: TFloatField
      FieldName = 'CustNo'
    end
    object CustomerCompany: TStringField
      FieldName = 'Company'
      Size = 30
    end
  end
  object BioLife: TTable
    DatabaseName = 'Phpdemo'
    SessionName = 'Session1_2'
    TableName = 'biolife.db'
    Left = 25
    Top = 126
    object BioLifeSpeciesNo: TFloatField
      FieldName = 'Species No'
    end
    object BioLifeCategory: TStringField
      FieldName = 'Category'
      Size = 15
    end
    object BioLifeCommon_Name: TStringField
      FieldName = 'Common_Name'
      Size = 30
    end
    object BioLifeSpeciesName: TStringField
      FieldName = 'Species Name'
      Size = 40
    end
    object BioLifeLengthcm: TFloatField
      FieldName = 'Length (cm)'
    end
    object BioLifeLength_In: TFloatField
      FieldName = 'Length_In'
    end
    object BioLifeNotes: TMemoField
      FieldName = 'Notes'
      OnGetText = BioLifeNotesGetText
      BlobType = ftMemo
      Size = 50
    end
    object BioLifeGraphic: TGraphicField
      FieldName = 'Graphic'
      OnGetText = BioLifeGraphicGetText
      BlobType = ftGraphic
    end
  end
  object Root: TPageProducer
    HTMLDoc.Strings = (
      '<HTML>'
      '<TITLE>PHP Example ( Former ISAPI/NSAPI/CGI Example)</TITLE>'
      '<BODY>'
      '<H3>PHP Example server</H3>'
      '<P>'
      '<B>Web Examples</B>'
      '<P>'
      '<B>TPageProducer using a Custom Tag</B><BR>'
      'For an example of using a TPageProducer with a Custom Tag click'
      
        '<A HREF="<#MODULENAME>?action=customerlist">here</A>.  This exam' +
        'ple returns'
      
        'list of all customers from the Customer.DB table.  You can click' +
        ' the customer'#39's'
      'name to view a listing of their orders.'
      '<P>'
      '<B>TDatasetPageProducer</B><BR>'
      
        'For an example of using the TDatasetPageProducer and of returnin' +
        'g a graphic'
      
        'from a table click <A HREF="<#MODULENAME>?action=biolife">here</' +
        'A>.  This example'
      
        'makes use of the JPeg unit to display a bitmap stored in the gra' +
        'phic field of the'
      'Biolife.DB table.'
      '<P>'
      '<B>Server Redirect</B><BR>'
      
        'Click <A HREF="<#MODULENAME>?action=redirect">here</A> for a dem' +
        'onstration of'
      'how to redirect a use to an other web site.<BR>'
      '</BODY>'
      '</HTML>'
      ''
      ''
      ' '
      ' ')
    OnHTMLTag = RootHTMLTag
    Left = 26
    Top = 176
  end
  object BioLifeProducer: TDataSetPageProducer
    HTMLDoc.Strings = (
      '<HTML>'
      '<HEAD>'
      '   <TITLE>Biolife Data</TITLE>'
      '</HEAD>'
      '<BODY>'
      '<TABLE BORDER=0 >'
      '<TR>'
      '<TD><B>Category:</B></TD>'
      ''
      '<TD><#Category></TD>'
      '</TR>'
      ''
      '<TR>'
      '<TD><B>Common Name:</B></TD>'
      ''
      '<TD><#Common_Name></TD>'
      '</TR>'
      ''
      '<TR>'
      '<TD VALIGN=TOP><B>Notes:</B></TD>'
      ''
      '<TD><#Notes></TD>'
      '</TR>'
      ''
      '<TR>'
      '<TD VALIGN=TOP><B>Picture:</B></TD>'
      ''
      '<TD><#Graphic></TD>'
      '</TR>'
      '</TABLE>'
      ''
      '</BODY>'
      '</HTML>')
    DataSet = BioLife
    Left = 110
    Top = 126
  end
  object CustSource: TDataSource
    DataSet = Customer
    Left = 90
    Top = 65
  end
  object CustomerOrders: TQueryTableProducer
    Caption = 'Customer Orders'
    Columns = <
      item
        FieldName = 'OrderNo'
      end
      item
        FieldName = 'SaleDate'
        Title.Align = haCenter
      end
      item
        FieldName = 'ShipDate'
      end>
    Query = Query1
    TableAttributes.Border = 1
    TableAttributes.CellSpacing = 1
    TableAttributes.CellPadding = 1
    TableAttributes.Width = 50
    Left = 170
    Top = 64
  end
  object CustomerList: TPageProducer
    HTMLDoc.Strings = (
      '<HTML>'
      '<!--------------------------------------------------->'
      '<!-- Copyright Inprise Corporation 1999 -->'
      '<!--------------------------------------------------->'
      '<HEAD>'
      '<TITLE>Sample Delphi Web server application</TITLE>'
      '</HEAD>'
      '<BODY>'
      '<H2>Customer Order Information</H2>'
      '<HR>'
      'Click a customer name to view their orders.<P>'
      '<#CUSTLIST><P>'
      '</BODY>'
      '</HTML>'
      ' ')
    OnHTMLTag = CustomerListHTMLTag
    Left = 118
    Top = 9
  end
  object Query1: TQuery
    DatabaseName = 'Phpdemo'
    SessionName = 'Session1_2'
    DataSource = CustSource
    SQL.Strings = (
      'SELECT *'
      'FROM ORDERS'
      'WHERE'
      '(CustNo = :CustNo)')
    Left = 24
    Top = 8
    ParamData = <
      item
        DataType = ftFloat
        Name = 'CustNo'
        ParamType = ptUnknown
      end>
  end
  object Database1: TDatabase
    AliasName = 'DBDEMOS'
    DatabaseName = 'Phpdemo'
    SessionName = 'Session1_2'
    Left = 240
    Top = 200
  end
  object Session1: TSession
    AutoSessionName = True
    Left = 164
    Top = 212
  end
end
