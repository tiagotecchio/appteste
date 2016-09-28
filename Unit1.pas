unit Unit1;

interface

uses
     Winapi.Windows,
     Winapi.Messages,
     System.SysUtils,
     System.Variants,
     System.Classes,
     Vcl.Graphics,
     SoapHTTPClient,
     SOAPHTTPTrans,
     SOAPConst,
     Vcl.Controls,
     Vcl.Forms,
     Vcl.Dialogs,
     Vcl.StdCtrls,
     IdBaseComponent,
     IdComponent,
     IdTCPConnection,
     IdTCPClient,
     IdHTTP,
     IdHeaderList,
     IdGlobalProtocols,
     httpsend,
     synautil;

type
     TForm1 = class(TForm)
          Button1: TButton;
          IdHTTP1: TIdHTTP;
          Memo1: TMemo;
          Button2: TButton;
          procedure Button1Click(Sender: TObject);
          procedure Button2Click(Sender: TObject);
     private
          { Private declarations }
     public
          { Public declarations }
     end;

var
     Form1          : TForm1;

implementation

{$R *.dfm}

function postar: boolean;
var
     lHTTP          : TIdHTTP;
     lParamList     : TStringList;
begin
     lParamList := TStringList.Create;
     lParamList.Add('id=1');

     lHTTP := TIdHTTP.Create(nil);
     try
          //Result := lHTTP.Post('http://www.ellitedigital.com.br/prolar/api/condominios/cadastrar', lParamList);
     finally
          lHTTP.Free;
          lParamList.Free;
     end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
     sresponse,
          sjson     : string;
     JsonToSend     : TStringStream;
     hl             : tidheaderlist;
begin
     sresponse := '';

     sjson := '{"codigo":3,"nome": "COND. XXXZZZ","apelido": "JARDIM EUROPA",' +
          '"observacoes": "Zelador DORVALINO BORDIGNON 9167-0432","cnpj": "90.479.684/0001-49",' +
          '"endereco": "RUA ANDRADE NEVES, 1060, EXPOSICAO - CAXIAS DO SUL/RS"}';

     //JsonToSend := TStringStream.Create(sJson, TEncoding.UTF8);
     JsonToSend := TStringStream.Create(Utf8Encode(SJson));
     try
          hl := TIdHeaderList.Create(QuotePlain);
          hl.FoldLines := False;
          hl.Add('Token: 48ff-f323-4453-sand');

          idhttp1.Request.ContentType := 'application/json';
          idhttp1.Request.CharSet := 'utf-8';
          idhttp1.Request.CustomHeaders := hl;

          memo1.Lines.Text := sjson;
          try
               sResponse := idhttp1.Post('http://www.ellitedigital.com.br/prolar/api/condominios/cadastrar', JsonToSend);
          except
               on E: Exception do
                    ShowMessage('Error on request: '#13#10 + e.Message);
          end;
     finally
          JsonToSend.Free;
     end;
     ShowMessage('r: ' + sresponse);
end;

function posta(const URL, URLData: string; const Data: TStream): Boolean;
var
     HTTP      : THTTPSend;
begin
     HTTP := THTTPSend.Create;
     try
          WriteStrToStream(HTTP.Document, URLData);
          //HTTP.MimeType := 'application/x-www-form-urlencoded';
          HTTP.MimeType := 'application/json';
          http.Headers.Add('Token: 48ff-f323-4453-sand');
          //Result := HTTP.HTTPMethod('POST', URL);
          Result := HTTP.HTTPMethod('PUT', URL);
          if Result then
               Data.CopyFrom(HTTP.Document, 0);
     finally
          HTTP.Free;
     end;
end;

function MemoryStreamToString(M: TMemoryStream): string;
begin
     SetString(Result, PAnsiChar(M.Memory), M.Size);
end;

procedure TForm1.Button2Click(Sender: TObject);
const
     URL            = 'http://www.ellitedigital.com.br/prolar/api/condominios/cadastrar';
     URL_Editar     = 'http://www.ellitedigital.com.br/prolar/api/condominios/editar/3';
var
     response       : TMemoryStream;
     sjson          : string;

begin
//     sjson := '{"codigo":3,"nome": "COND. XXXZZZ","apelido": "JARDIM EUROPA",' +
//              '"observacoes": "Zelador DORVALINO BORDIGNON 9167-0432","cnpj": "90.479.684/0001-49",' +
//              '"endereco": "RUA ANDRADE NEVES, 1060, EXPOSICAO - CAXIAS DO SUL/RS"}';

    sjson := '{"nome": "COND. ED. BELO HORIZONTE","apelido": "BELO HORIZONTE",' +
              '"observacoes": "Zelador VANDERLEI 3019-4752","cnpj": "90.479.981/0001-94",' +
              '"endereco": "RUA ANDRADE NEVES, 1048, LOURDES - CAXIAS DO SUL/RS"}';

     Response := TMemoryStream.Create;
     try
        if posta(url_editar, sjson, response) then
           ShowMessage( MemoryStreamToString(response) );
     finally
          response.Free;
     end;
end;

end.

