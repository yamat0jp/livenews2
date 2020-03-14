object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      MethodType = mtGet
      Name = 'top'
      PathInfo = '/top'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'help'
      PathInfo = '/help'
    end
    item
      MethodType = mtGet
      Name = 'detail'
      PathInfo = '/backnumber'
      OnAction = WebModule1detailAction
    end
    item
      Name = 'upload'
      PathInfo = '/upload'
      OnAction = WebModule1uploadAction
    end
    item
      Name = 'selection'
      PathInfo = '/reader/select'
      OnAction = WebModule1selectionAction
    end
    item
      Name = 'readerData'
      PathInfo = '/reader/data'
      OnAction = WebModule1readerDataAction
    end
    item
      Name = 'readerTop'
      PathInfo = '/reader/top'
      OnAction = WebModule1readerTopAction
    end
    item
      Name = 'writerData'
      PathInfo = '/writer/data'
      OnAction = WebModule1writerDataAction
    end
    item
      Name = 'writerTop'
      PathInfo = '/writer/top'
      OnAction = WebModule1writerTopAction
    end
    item
      MethodType = mtPost
      Name = 'writeMag'
      PathInfo = '/writer/regist'
      OnAction = WebModule1writeMagAction
    end
    item
      Name = 'writerpage'
      PathInfo = '/writer/page'
      OnAction = WebModule1writerpageAction
    end
    item
      MethodType = mtPost
      Name = 'login'
      PathInfo = '/reader/login'
      OnAction = WebModule1loginAction
    end
    item
      Name = 'login2'
      PathInfo = '/writer/login'
      OnAction = WebModule1login2Action
    end
    item
      MethodType = mtPost
      Name = 'logout'
      PathInfo = '/logout'
      OnAction = WebModule1logoutAction
    end
    item
      MethodType = mtGet
      Name = 'mainView'
      PathInfo = '/reader/top'
      OnAction = WebModule1mainViewAction
    end
    item
      MethodType = mtGet
      Name = 'image'
      PathInfo = '/image'
      OnAction = WebModule1imageAction
    end
    item
      Enabled = False
      Name = 'sumbnail'
      PathInfo = '/sum'
    end>
  Height = 225
  Width = 415
  object readerTop: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="en">'
      '<head>'
      '    <meta charset="UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1.0">'
      '    <title>Document</title>'
      '</head>'
      '<body>'
      '        <p>'#12354#12394#12383#12398#26412#26842#12391#12377
      '    {{#mag}}'
      '        <table border=1>'
      '        <th>{{magName}} writed by {{writer}}<ht>'
      '        <tr><td>{{comment}}</td></tr>'
      '        <tr><td>{{day}}</td></tr>'
      '        <tr><td>{{lastDay}}</td></tr>'
      '        {{^enable}}<tr><td>'#20241#21002#20013'</td></tr>{{/enable}}'
      '        </table>'
      '    {{/mag}}'
      '    <p><a href=/top>'#12488#12483#12503'</a>'#12506#12540#12472#12408#25147#12387#12390#36861#21152#12375#12414#12375#12423#12358
      '    <hr>'
      '    <p>'#22522#26412#24773#22577
      '    {{#reader}}'
      '        <form method=post action=/reader/data>'
      '        <input type=hidden name="_method" value=put>'
      '        <p>name : {{name}}'
      '        <p>mail : {{mail}} <input type=text name=mail>'
      
        '        <p>password : *** <input type=text name=password>=><inpu' +
        't type=password name=new>'
      '        <input type=submit value="'#22793#26356'">'
      '        </form>'
      '    {{/reader}}'
      '</body>'
      '</html>')
    Left = 48
    Top = 24
  end
  object top: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="en">'
      '<head>'
      '    <title>Document'
      '</title>'
      '    <meta charset="UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1.0">'
      '</head>'
      '<body>'
      '    {{#id}}'
      '        <p>'#12525#12464#12450#12454#12488
      '        <form method=post action=/logout>'
      '        <input type=submit>'
      '        </form>'
      
        '        <a href=/reader/top>'#12518#12540#12470#12540#12507#12540#12512'</a>'#12288#12289'<a href=/reader/data>'#12518#12540 +
        #12470#12540#24773#22577'</a>'
      '    {{/id}}'
      '    {{^id}}'
      '        <p>'#12525#12464#12452#12531
      '        <form method=post action=/reader/login>'
      
        '        <p>mail : <input type=text name=mail>password : <input t' +
        'ype=password name=password>'
      '        <input type=submit>'
      '        </form>'
      '        <p>'#26032#35215#30331#37682
      '        <form method=post action=/reader/data>'
      
        '        <p>name : <input type=text name=reader> mail : <input ty' +
        'pe=text name=mail>'
      
        '        password : <input type=password name=password><input typ' +
        'e=submit>'
      '        </form>'
      '    {{/id}}'
      '    {{#items}}'
      '        {{#enable}}'
      '                <table border=1>'
      '                <th><a href=/backnumber?id={{magNum}}>'
      '                        {{magName}}</a> writed by {{writer}}'
      '                        {{^fun}}{{#id}}'
      
        '                        <form method=post action=/reader/select?' +
        'name={{magNum}}>'
      '                        <input type=submit value="'#30331#37682'"></form>'
      '                        {{/id}}{{/fun}}'
      '                </th>'
      '                <tr><td>{{comment}}</td></tr>'
      '                <tr><td>{{day}}</td></tr>'
      '                <tr><td>{{lastDay}}</td></tr>'
      '                <tr><td>{{count}}</td></tr>'
      '                </table>'
      '        {{/enable}}'
      '    {{/items}}'
      '    <hr id=message>'
      '    {{#comment}}'
      '        <p>'#12513#12483#12475#12540#12472
      '        {{.}}'
      '    {{/comment}}'
      '    <p>'#35352#32773#12398#26041#12399'<a href=/writer/page>'#12371#12385#12425'</a>'#12363#12425#12525#12464#12452#12531
      '</body>'
      '</html>')
    Left = 112
    Top = 24
  end
  object writerTop: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="ja">'
      '<head>'
      '    <meta charset="UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1.0">'
      '    <title>Document</title>'
      '</head>'
      '<body>'
      '        <h3>'#26032#21002#30331#37682'</h3>'
      '        <p>'#26360#31821#24773#22577
      '        <form method=post action=/writer/regist>'
      '                <p>'#12479#12452#12488#12523
      '                <p>'
      '                <input type=text name=name>'
      '                <p>'#35500#26126#27396
      '                <p>'
      '                <input type=text name=comment>'
      '                <p>'#30330#34892#20104#23450#26085
      '                <p>'
      '                <input type=text name=day>'
      '                <p>'
      '                <input type=submit>'
      '        </form>'
      '        <p>'#30331#37682#20013#12398#12510#12460#12472#12531#12391#12377
      '        {{#mag}}'
      '                <hr>'
      
        '                <p><a href=/upload?num={{magnum}}>'#12479#12452#12488#12523'{{name}}</' +
        'a>'
      '                <p>{{comment}}'
      '                <p>'#30331#37682#26085'{{day}}'
      '                <p>'#26368#32066#26356#26032#26085'{{last}}'
      '                <p>'#35501#32773#25968'{{count}}'
      '        {{/mag}}'
      '        {{^mag}}'
      '                <p>0'#20874#12398#30330#34892#12391#12377
      '        {{/mag}}'
      '</body>'
      '</html')
    Left = 168
    Top = 24
  end
  object writerData: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="en">'
      '<head>'
      '    <meta charset="UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1.0">'
      '    <title>Document</title>'
      '</head>'
      '<body>'
      '        <form method=post action=/writer/data>'
      '        <input type=hidden name="_method" value=put>'
      '        <p>name : {{name}}<input type=text name=writer>'
      '        <p>mail : {{mail}}<input type=text name=mail>'
      '        <p>password : ***<input type=password name=password>'
      '        <input type=submit>'
      '        </form>'
      '        <a href=/writer/top>'#12521#12452#12479#12540'TOP</a>'#12408#31227#21205#12377#12427
      '        <form method=post action=/writer/data>'
      '        <input type=hidden name="_method" value=delete>'
      '        <input type=submit value="'#36864#20250'">'
      '        </form>'
      '</body>'
      '</html>')
    Left = 168
    Top = 80
  end
  object backnumber: TPageProducer
    HTMLDoc.Strings = (
      '        {{#data}}'
      '                <hr>'
      '                {{&text}}'
      '        {{/data}}')
    Left = 304
    Top = 80
  end
  object mainView: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="ja">'
      '<head>'
      '    <meta charset="UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1.0">'
      '    <title>Document</title>'
      '</head>'
      '<body>'
      '        <p>'#12491#12517#12540#12473#12398#25968#12293#12434#12362#27005#12375#12415#12367#12384#12373#12356
      '        {{#mag}}'
      '        <hr>'
      '                <p>[{{magName}}] ({{day}})'
      '                <p>by {{writer}}'
      '                {{&text}}'
      '                {{#changed}}'
      '                        <p>{{hint}}'
      '                {{/changed}}'
      '        {{/mag}}'
      '</body>'
      '</html>')
    Left = 240
    Top = 24
  end
  object writerpage: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="en">'
      '<head>'
      '    <title>Document'
      '</title>'
      '    <meta charset="UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1.0">'
      '</head>'
      '<body>'
      '    {{^login}}'
      '    <p>'#12525#12464#12452#12531
      '    <form method=post action=/writer/login>'
      '        <input type=text name=mail>'
      '        <input type=password name=password>'
      '        <input type=submit value=login>'
      '    </form>'
      '    <p>'#26032#35215#35352#32773#30331#37682
      '    <form method=post action=/writer/data>'
      '        <input type=text name=writer>'
      '        <input type=text name=mail>'
      '        <input type=password name=password>'
      '        <input type=submit name=regWriter value=send>'
      '    </form>'
      '    {{/login}}'
      '    {{#login}}'
      '        <form method=post action=/logout>'
      '        <input type=submit value=logout>'
      '        </form>'
      '    <p><a href=/writer/top>'#12507#12540#12512'</a>'#12288#12289#12288'<a href=/writer/data>'#24773#22577'</a>'
      '    {{/login}}'
      '    <p>'#39015#23458#12391#12354#12427#12521#12452#12479#12540#12408#12398#35500#26126#12394#12393#26360#12365#12383#12356
      '</body>'
      '</html>')
    Left = 168
    Top = 136
  end
  object upload: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="en">'
      '<head>'
      '    <meta charset="UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1.0">'
      '    <title>Document</title>'
      '</head>'
      '<body>'
      '        <h1>UPLOAD PAGE</h1>'
      
        '        <form method=post action=/upload?num={{magnum}} enctype=' +
        '"multipart/form-data" accept="*.epub">'
      '        <input type=file name=epub>'
      '        <input type=submit value="'#36865#20449'">'
      '        </form>'
      '        <h3>'#26360#31821#24773#22577'</h3>'
      '        <p>{{name}}'
      '        <p>{{comment}}'
      '        <#main>'
      '</body>'
      '</html>')
    OnHTMLTag = uploadHTMLTag
    Left = 304
    Top = 24
  end
  object mags: TPageProducer
    HTMLDoc.Strings = (
      '<!DOCTYPE html>'
      '<html lang="en">'
      '<head>'
      '    <meta charset="UTF-8">'
      
        '    <meta name="viewport" content="width=device-width, initial-s' +
        'cale=1.0">'
      '    <title>Document</title>'
      '</head>'
      '<body>'
      '        <p>{{name}}'
      '        <p>{{comment}}'
      '        <#main>'
      '        {{#id}}'
      '        <form method=post action=/reader/select>'
      '        <input type=submit value="'#30331#37682'">'
      '        </form>'
      '        {{/id}}'
      '</body>'
      '</html>')
    OnHTMLTag = magsHTMLTag
    Left = 112
    Top = 80
  end
end
