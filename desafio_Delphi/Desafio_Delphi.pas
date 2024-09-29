unit Desafio_Delphi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Vcl.StdCtrls,
  Vcl.ComCtrls, System.JSON;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Edit1: TEdit;   // Campo para o nome do produto
    Edit2: TEdit;   // Campo para o preço do produto
    Button1: TButton; // Botão de Adicionar
    Button2: TButton; // Botão de Atualizar
    Button3: TButton; // Botão de Excluir
    Label1: TLabel;
    Label2: TLabel;
    NetHTTPClient1: TNetHTTPClient;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);  // Adicionar produto
    procedure Button2Click(Sender: TObject);  // Atualizar produto
    procedure Button3Click(Sender: TObject);  // Excluir produto
    procedure ListView1Click(Sender: TObject); // Selecionar produto na lista
  private
    procedure LoadProducts;  // Método para carregar produtos da API
    procedure AddProduct;    // Método para adicionar produto
    procedure UpdateProduct; // Método para atualizar produto
    procedure DeleteProduct; // Método para excluir produto
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  LoadProducts;  // Carregar produtos ao iniciar a aplicação
end;

procedure TForm1.LoadProducts;
var
  Response: IHTTPResponse;
  JsonArray: TJSONArray;
  i: Integer;
  ListItem: TListItem;
begin
  try
    // Faz a requisição GET para a API de produtos
    Response := NetHTTPClient1.Get('http://localhost:3000/products');

    if Response.StatusCode = 200 then
    begin
      // Limpa o ListView antes de carregar os novos produtos
      ListView1.Items.Clear;

      // Faz o parse do JSON de resposta
      JsonArray := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONArray;

      for i := 0 to JsonArray.Count - 1 do
      begin
        // Adiciona itens ao ListView com os dados da API
        ListItem := ListView1.Items.Add;
        ListItem.Caption := JsonArray.Items[i].GetValue<string>('id');
        ListItem.SubItems.Add(JsonArray.Items[i].GetValue<string>('name'));
        ListItem.SubItems.Add(FloatToStr(JsonArray.Items[i].GetValue<Double>('price')));
      end;

      JsonArray.Free;
    end
    else
      ShowMessage('Erro ao carregar produtos: ' + Response.ContentAsString);
  except
    on E: Exception do
      ShowMessage('Erro de conexão: ' + E.Message);
  end;
end;

procedure TForm1.AddProduct;
var
  Response: IHTTPResponse;
  JsonBody: TJSONObject;
  ProductName: string;
  ProductPrice: Double;
  PostData: TStringStream;
begin
  ProductName := Edit1.Text;
  ProductPrice := StrToFloat(Edit2.Text);

  // Criar o JSON para enviar na requisição POST
  JsonBody := TJSONObject.Create;
  try
    JsonBody.AddPair('name', ProductName);
    JsonBody.AddPair('price', TJSONNumber.Create(ProductPrice));
    PostData := TStringStream.Create(JsonBody.ToString, TEncoding.UTF8);
    try
      // Faz a requisição POST
      Response := NetHTTPClient1.Post('http://localhost:3000/products', PostData, nil, [TNetHeader.Create('Content-Type', 'application/json')]);

      if Response.StatusCode = 201 then
        LoadProducts // Recarrega os produtos após adicionar
      else
        ShowMessage('Erro ao adicionar produto: ' + Response.ContentAsString);
    finally
      PostData.Free;
    end;
  finally
    JsonBody.Free;
  end;
end;

procedure TForm1.UpdateProduct;
var
  Response: IHTTPResponse;
  JsonBody: TJSONObject;
  ProductID: string;
  ProductName: string;
  ProductPrice: Double;
  PutData: TStringStream;
begin
  if ListView1.Selected = nil then
  begin
    ShowMessage('Selecione um produto para atualizar.');
    Exit;
  end;

  // Pega o ID do produto selecionado no ListView
  ProductID := ListView1.Selected.Caption;
  ProductName := Edit1.Text;
  ProductPrice := StrToFloat(Edit2.Text);

  // Criar o JSON para enviar na requisição PUT
  JsonBody := TJSONObject.Create;
  try
    JsonBody.AddPair('name', ProductName);
    JsonBody.AddPair('price', TJSONNumber.Create(ProductPrice));
    PutData := TStringStream.Create(JsonBody.ToString, TEncoding.UTF8);
    try
      // Faz a requisição PUT para atualizar o produto
      Response := NetHTTPClient1.Put('http://localhost:3000/products/' + ProductID, PutData, nil, [TNetHeader.Create('Content-Type', 'application/json')]);

      if Response.StatusCode = 200 then
        LoadProducts // Recarrega os produtos após atualizar
      else
        ShowMessage('Erro ao atualizar produto: ' + Response.ContentAsString);
    finally
      PutData.Free;
    end;
  finally
    JsonBody.Free;
  end;
end;

procedure TForm1.DeleteProduct;
var
  Response: IHTTPResponse;
  ProductID: string;
begin
  if ListView1.Selected = nil then
  begin
    ShowMessage('Selecione um produto para excluir.');
    Exit;
  end;

  // Pega o ID do produto selecionado no ListView
  ProductID := ListView1.Selected.Caption;

  // Faz a requisição DELETE para excluir o produto
  Response := NetHTTPClient1.Delete('http://localhost:3000/products/' + ProductID);

  if Response.StatusCode = 204 then
    LoadProducts // Recarrega os produtos após excluir
  else
    ShowMessage('Erro ao excluir produto: ' + Response.ContentAsString);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  AddProduct;  // Chama o método de adicionar produto
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  UpdateProduct;  // Chama o método de atualizar produto
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  DeleteProduct;  // Chama o método de excluir produto
end;

procedure TForm1.ListView1Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  begin
    // Preenche os campos Edit com os valores do produto selecionado no ListView
    Edit1.Text := ListView1.Selected.SubItems[0];  // Nome do produto
    Edit2.Text := ListView1.Selected.SubItems[1];  // Preço do produto
  end;
end;

end.

