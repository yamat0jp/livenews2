object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 299
  ClientWidth = 896
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 711
    Height = 299
    Align = alClient
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 711
    Top = 0
    Width = 185
    Height = 299
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 1
    object Button2: TButton
      Left = 54
      Top = 138
      Width = 75
      Height = 25
      Caption = 'execute'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 56
      Top = 32
      Width = 75
      Height = 25
      Caption = 'clear'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Edit1: TEdit
      Left = 32
      Top = 248
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object Button4: TButton
      Left = 56
      Top = 79
      Width = 75
      Height = 25
      Caption = 'refresh'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object NewstableConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=newstable')
    Connected = True
    LoginPrompt = False
    Left = 227
    Top = 36
  end
  object FDTable1: TFDTable
    Active = True
    Filtered = True
    IndexFieldNames = 'magId'
    Connection = NewstableConnection
    UpdateOptions.UpdateTableName = 'newstable.mag'
    TableName = 'newstable.mag'
    Left = 224
    Top = 96
    object FDTable1magId: TIntegerField
      FieldName = 'magId'
      Origin = 'magId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDTable1magNum: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'magNum'
      Origin = 'magNum'
      Size = 10
    end
    object FDTable1magName: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'magName'
      Origin = 'magName'
    end
    object FDTable1comment: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'comment'
      Origin = 'comment'
      Size = 50
    end
    object FDTable1day: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'day'
      Origin = '`day`'
    end
    object FDTable1lastDay: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'lastDay'
      Origin = 'lastDay'
    end
    object FDTable1enable: TBooleanField
      AutoGenerateValue = arDefault
      FieldName = 'enable'
      Origin = '`enable`'
    end
  end
  object DataSource1: TDataSource
    DataSet = FDTable1
    Left = 224
    Top = 160
  end
  object FDQuery1: TFDQuery
    Connection = NewstableConnection
    SQL.Strings = (
      'select MAX(magId) as id from mag;')
    Left = 320
    Top = 96
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 320
    Top = 160
  end
  object FDTable2: TFDTable
    Active = True
    IndexFieldNames = 'serial'
    Connection = NewstableConnection
    UpdateOptions.UpdateTableName = 'newstable.db'
    TableName = 'newstable.db'
    Left = 448
    Top = 96
    object FDTable2serial: TIntegerField
      FieldName = 'serial'
      Origin = '`serial`'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDTable2magId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'magId'
      Origin = 'magId'
    end
    object FDTable2readerId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'readerId'
      Origin = 'readerId'
    end
    object FDTable2writerId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'writerId'
      Origin = 'writerId'
    end
  end
  object FDTable3: TFDTable
    Active = True
    IndexFieldNames = 'writerId'
    Connection = NewstableConnection
    UpdateOptions.UpdateTableName = 'newstable.writer'
    TableName = 'newstable.writer'
    Left = 448
    Top = 160
    object FDTable3writerId: TIntegerField
      FieldName = 'writerId'
      Origin = 'writerId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDTable3writer: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'writer'
      Origin = 'writer'
    end
    object FDTable3mail: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'mail'
      Origin = 'mail'
    end
    object FDTable3password: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'password'
      Origin = '`password`'
    end
  end
  object BindSourceDB1: TBindSourceDB
    DataSet = FDTable3
    ScopeMappings = <>
    Left = 408
    Top = 224
  end
  object BindingsList1: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 20
    Top = 5
    object LinkControlToField1: TLinkControlToField
      Category = #12463#12452#12483#12463' '#12496#12452#12531#12487#12451#12531#12464
      DataSource = BindSourceDB1
      FieldName = 'writer'
      Control = Edit1
      Track = True
    end
  end
end
