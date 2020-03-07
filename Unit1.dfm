object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 257
  Width = 299
  object database: TFDTable
    IndexFieldNames = 'no'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'database'
    TableName = 'database'
    Left = 48
    Top = 128
  end
  object indexTable: TFDTable
    IndexFieldNames = 'readerId;magId'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'indexTable'
    TableName = 'indexTable'
    Left = 208
    Top = 80
    object indexTablereaderId: TIntegerField
      FieldName = 'readerId'
      Origin = 'readerId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object indexTablemagId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'magId'
      Origin = 'magId'
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
  object magList: TFDTable
    IndexFieldNames = 'writerId;magId'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'magList'
    TableName = 'magList'
    Left = 128
    Top = 128
    object magListwriterId: TIntegerField
      FieldName = 'writerId'
      Origin = 'writerId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object magListmagId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'magId'
      Origin = 'magId'
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
    Left = 48
    Top = 80
  end
  object news: TFDTable
    IndexFieldNames = 'no;magId'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'news'
    TableName = 'news'
    Left = 128
    Top = 184
    object newsmagId: TIntegerField
      FieldName = 'magId'
      Origin = 'magId'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object newsnewsId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'newsId'
      Calculated = True
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
    IndexFieldNames = 'id'
    Connection = MagazineConnection
    UpdateOptions.UpdateTableName = 'image'
    TableName = 'image'
    Left = 48
    Top = 184
  end
end
