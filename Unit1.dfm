object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 257
  Width = 299
  object db: TFDTable
    IndexFieldNames = 'serial'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'newstable.db'
    TableName = 'newstable.db'
    Left = 48
    Top = 136
    object dbserial: TIntegerField
      FieldName = 'serial'
      Origin = '`serial`'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object dbwriterId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'writerId'
      Origin = 'writerId'
    end
    object dbmagId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'magId'
      Origin = 'magId'
    end
    object dbreaderId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'readerId'
      Origin = 'readerId'
    end
  end
  object reader: TFDTable
    IndexFieldNames = 'readerId'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'reader'
    TableName = 'reader'
    Left = 208
    Top = 32
    object readerreaderId: TIntegerField
      FieldName = 'readerId'
      Origin = 'readerId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object readerreader: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'reader'
      Origin = 'reader'
    end
    object readermail: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'mail'
      Origin = 'mail'
    end
    object readerpassword: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'password'
      Origin = '`password`'
    end
  end
  object MagazineConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=newstable')
    Connected = True
    LoginPrompt = False
    Left = 52
    Top = 29
  end
  object FDQuery1: TFDQuery
    Connection = MagazineConnection
    SQL.Strings = (
      '')
    Left = 72
    Top = 80
  end
  object news: TFDTable
    IndexFieldNames = 'number;magId;newsId'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'news'
    TableName = 'news'
    Left = 128
    Top = 184
    object newsnumber: TIntegerField
      FieldName = 'number'
      Origin = '`number`'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object newsmagId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'magId'
      Origin = 'magId'
    end
    object newsnewsId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'newsId'
      Origin = 'newsId'
    end
    object newsfiles: TWideMemoField
      AutoGenerateValue = arDefault
      FieldName = 'files'
      Origin = 'files'
      BlobType = ftWideMemo
    end
    object newsday: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'day'
      Origin = '`day`'
    end
    object newschanged: TBooleanField
      AutoGenerateValue = arDefault
      FieldName = 'changed'
      Origin = 'changed'
    end
    object newsenabled: TBooleanField
      AutoGenerateValue = arDefault
      FieldName = 'enabled'
      Origin = 'enabled'
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 208
    Top = 184
  end
  object writer: TFDTable
    IndexFieldNames = 'writerId'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'writer'
    TableName = 'writer'
    Left = 128
    Top = 80
    object writerwriterId: TIntegerField
      FieldName = 'writerId'
      Origin = 'writerId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object writerwriter: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'writer'
      Origin = 'writer'
    end
    object writermail: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'mail'
      Origin = 'mail'
    end
    object writerpassword: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'password'
      Origin = '`password`'
    end
  end
  object mag: TFDTable
    IndexFieldNames = 'magId'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'mag'
    TableName = 'mag'
    Left = 128
    Top = 32
    object magmagId: TIntegerField
      FieldName = 'magId'
      Origin = 'magId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object magmagNum: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'magNum'
      Origin = 'magNum'
      Size = 10
    end
    object magmagName: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'magName'
      Origin = 'magName'
    end
    object magcomment: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'comment'
      Origin = 'comment'
      Size = 50
    end
    object magday: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'day'
      Origin = '`day`'
    end
    object maglastDay: TDateField
      AutoGenerateValue = arDefault
      FieldName = 'lastDay'
      Origin = 'lastDay'
    end
    object magenable: TBooleanField
      AutoGenerateValue = arDefault
      FieldName = 'enable'
      Origin = '`enable`'
    end
  end
  object image: TFDTable
    IndexFieldNames = 'magId;newsId'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'image'
    TableName = 'image'
    Left = 48
    Top = 184
    object imageimgId: TIntegerField
      FieldName = 'imgId'
    end
    object imagemagId: TIntegerField
      FieldName = 'magId'
      Origin = 'magId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object imagenewsId: TIntegerField
      FieldName = 'newsId'
      Origin = 'newsId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object imagewriterId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'writerId'
      Origin = 'writerId'
    end
    object imagename: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'name'
      Origin = '`name`'
    end
    object imagecopyright: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'copyright'
      Origin = 'copyright'
    end
    object imagedata: TBlobField
      AutoGenerateValue = arDefault
      FieldName = 'data'
      Origin = '`data`'
    end
    object imageencode: TBooleanField
      AutoGenerateValue = arDefault
      FieldName = 'encode'
      Origin = 'encode'
    end
  end
  object FDQuery2: TFDQuery
    Connection = MagazineConnection
    Left = 16
    Top = 80
  end
end
