unit Main_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Types, ExtCtrls, Vcl.StdCtrls, System.UITypes;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    btnGenerate: TButton;
    edtTamanho: TEdit;
    Label1: TLabel;
    btnStartStop: TButton;
    Timer: TTimer;
    lbl1: TLabel;
    edtGeracao: TEdit;
    lbl2: TLabel;
    edtGeracaoMaxima: TEdit;
    lbl3: TLabel;
    edtSpeed: TEdit;
    chkAutoContraste: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    function getLivingNeighbors(X, Y: Integer): Integer;
    procedure btnStartStopClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkAutoContrasteClick(Sender: TObject);
    procedure edtTamanhoExit(Sender: TObject);
  private
    procedure OnCellMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Update;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
  uses
    Cell_u;

  var
    cell: TCell;
    arrCell: array of array of TCell;
    vSize: Integer;
    vPoint: TPoint;
    X: Integer;
    Y: Integer;
    vSizeCell: Integer;
    vCellsUpdated: array of array of Boolean;
    vGridGerado: Boolean;
    vGeracao: Integer;
    vGeracaoMaxima: Integer;
    vUpdatespeed: Integer;
    vContraste: Boolean;
    vDeadCount: Integer;
    vLastState: Boolean;
{$R *.dfm}

procedure TForm2.btnStartStopClick(Sender: TObject);
begin
  if ((edtSpeed.Text = '') or (edtSpeed.Text = '0')) then
  begin
    ShowMessage('Insira uma velocidade maior que 0.');
    edtSpeed.SetFocus;
    Abort;
  end;
  vUpdatespeed := StrToInt(edtSpeed.Text);
  Timer.Interval := vUpdatespeed;

  if vGridGerado = False then
  begin
    ShowMessage('É necessário gerar o Grid.');
    edtTamanho.SetFocus;
    Abort;
  end;
  if Timer.Enabled then
  begin
    Timer.Enabled := False;
    btnStartStop.Caption := 'Start';
    edtTamanho.Enabled := True;
    btnGenerate.Enabled := True;
    chkAutoContraste.Enabled := True;
    edtSpeed.Enabled := True;
  end
  else
  begin
    Timer.Enabled := True;
    btnStartStop.Caption := 'Stop';
    edtTamanho.Enabled := False;
    btnGenerate.Enabled := False;
    chkAutoContraste.Enabled := False;
    edtSpeed.Enabled := False;
  end;

end;

procedure TForm2.chkAutoContrasteClick(Sender: TObject);
var
  i, j: Integer;
begin
  if chkAutoContraste.Checked then
  begin
    for i := 0 to vSize -1 do
    begin
      for j := 0 to vSize -1 do
      begin
        arrCell[i, j].Retangulo.Pen.Color := clBlack;
        if arrCell[i, j].Retangulo.Brush.Color = clWhite then
        begin
          arrCell[i, j].Retangulo.Brush.Color := clBlack;
          arrCell[i, j].Live := False;
        end
        else if arrCell[i, j].Retangulo.Brush.Color = clBlack then
        begin
          arrCell[i, j].Retangulo.Brush.Color := clWhite;
          arrCell[i, j].Live := True;
        end;
      end;
    end;
  end
  else if not(chkAutoContraste.Checked) then
  begin
    for i := 0 to vSize -1 do
    begin
      for j := 0 to vSize -1 do
      begin
        arrCell[i, j].Retangulo.Pen.Color := clGray;
        if arrCell[i, j].Retangulo.Brush.Color = clWhite then
        begin
          arrCell[i, j].Retangulo.Brush.Color := clBlack;
          arrCell[i, j].Live := True;
        end
        else if arrCell[i, j].Retangulo.Brush.Color = clBlack then
        begin
          arrCell[i, j].Retangulo.Brush.Color := clWhite;
          arrCell[i, j].Live := False;
        end;
      end;
    end;
  end;
end;

procedure TForm2.edtTamanhoExit(Sender: TObject);
begin
  vSize := StrToInt(edtTamanho.Text);
end;

procedure TForm2.btnGenerateClick(Sender: TObject);
var
  i, j: Integer;
  vPanelSize: Integer;
begin
  if edtTamanho.Text = '' then
  begin
    ShowMessage('Insira um numero.');
    Abort;
  end;

  if edtTamanho.Text = '0' then
  begin
    ShowMessage('Tamanho precisa ser maior que zero.');
    Abort;
  end;

  if Length(arrCell) > 0 then
  begin
    for i := 0 to Length(arrCell)-1 do
    begin
      for j := 0 to Length(arrCell)-1 do
      begin
        arrCell[i, j].Retangulo.Destroy;
        arrCell[i, j].Destroy;
        vCellsUpdated[i, j] := False;
      end;
    end;
  end;

  vDeadCount := 0;
  SetLength(arrCell, 0, 0);
  SetLength(vCellsUpdated, 0, 0);
  vDeadCount := vSize*vSize;
  vGeracao := 0;
  vSize := StrToInt(edtTamanho.Text);
  vPanelSize := Panel1.Width;
  vSizeCell := Round(vPanelSize/vSize);
  SetLength(arrCell, vSize, vSize);
  SetLength(vCellsUpdated, vSize, vSize);
  X := 0;
  Y := 0;
  for i := 0 to vSize-1 do
  begin
    for j := 0 to vSize-1 do
    begin
      vPoint.X := X;
      vPoint.Y := Y;
      arrCell[i, j] := TCell.Create;
      arrCell[i, j].Ponto := vPoint;
      arrCell[i, j].Retangulo := TShape.Create(self);
      arrCell[i, j].Retangulo.Parent := Panel1;
      arrCell[i, j].Retangulo.Brush.Color := clWhite;
      arrCell[i, j].Retangulo.Pen.Color := clLtGray;
      arrCell[i, j].Retangulo.Pen.Style := psSolid;
      arrCell[i, j].Retangulo.SetBounds(arrCell[i, j].Ponto.X, arrCell[i, j].Ponto.Y, vSizeCell, vSizeCell);
      arrCell[i, j].Retangulo.OnMouseDown := OnCellMouseDown;
      X := vPoint.X + vSizeCell;
    end;
    X := 0;
    Y := vPoint.Y + vSizeCell;
  end;
  vGridGerado := True;
  chkAutoContraste.Enabled := True;
  vGeracao := 0;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  cell := TCell.Create;
  Timer.Enabled := False;
  vGridGerado := False;
  vGeracao := 0;
  vGeracaoMaxima := 0;
  vUpdatespeed := 500;

end;

procedure TForm2.FormShow(Sender: TObject);
begin
  edtTamanho.SetFocus;
  edtSpeed.Text := IntToStr(vUpdatespeed);
  edtGeracao.Text := IntToStr(vGeracao);
  edtGeracaoMaxima.Text := IntToStr(vGeracaoMaxima);
  chkAutoContraste.Enabled := False;
end;

procedure TForm2.OnCellMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, j: Integer;
  Point: TPoint;
begin
  if Sender is TShape then
  begin
    Point.X := TShape(Sender).Left;
    Point.Y := TShape(Sender).Top;

    if not(chkAutoContraste.Checked) then
    begin
      if TShape(Sender).Brush.Color = clWhite then
      begin
        TShape(Sender).Brush.Color := clBlack;
        for i := 0 to vSize-1 do
        begin
          for j := 0 to vSize-1 do
          begin
            if arrCell[i, j].Ponto = Point then
            begin
              arrCell[i, j].Live := True;
              Abort;
            end;
          end;
        end;
      end
      else if TShape(Sender).Brush.Color = clBlack then
      begin
        TShape(Sender).Brush.Color := clWhite;
        for i := 0 to vSize-1 do
        begin
          for j := 0 to vSize-1 do
          begin
            if arrCell[i, j].Ponto = Point then
            begin
              arrCell[i, j].Live := False;
              Abort;
            end;
          end;
        end;
      end;
    end
    else if chkAutoContraste.Checked then
    begin
      if TShape(Sender).Brush.Color = clWhite then
      begin
        TShape(Sender).Brush.Color := clBlack;
        for i := 0 to vSize-1 do
        begin
          for j := 0 to vSize-1 do
          begin
            if arrCell[i, j].Ponto = Point then
            begin
              arrCell[i, j].Live := False;
              Abort;
            end;
          end;
        end;
      end
      else if TShape(Sender).Brush.Color = clBlack then
      begin
        TShape(Sender).Brush.Color := clWhite;
        for i := 0 to vSize-1 do
        begin
          for j := 0 to vSize-1 do
          begin
            if arrCell[i, j].Ponto = Point then
            begin
              arrCell[i, j].Live := True;
              Abort;
            end;
          end;
        end;
      end;
    end;


  end
  else
  ShowMessage('Algo errado');
end;

procedure TForm2.TimerTimer(Sender: TObject);
begin
   Update;
end;

procedure TForm2.Update;
var
  i, j, count: Integer;
  living, result: Boolean;
begin
  edtTamanho.Enabled := False;
  btnGenerate.Enabled := False;
  for i := 0 to vSize-1 do
  begin
    for j := 0 to vSize-1 do
    begin
      living := arrCell[i, j].Live;
      result := False;
      count := getLivingNeighbors(i, j);

      if (living) and (count < 2) then
      begin
        result := false;
      end
      else if ((living) and ((count = 2) or (count = 3))) then
      begin
        result := True;
      end
      else if (living) and (count > 3) then
      begin
        result := False;
      end
      else if (not(living) and (count = 3)) then
      begin
        result := True;
      end;

      vCellsUpdated[i, j] := result;
    end;
  end;



  for i := 0 to vSize-1 do
  begin
    for j := 0 to vSize-1 do
    begin
      arrCell[i, j].Live := vCellsUpdated[i, j];
      if ((arrCell[i, j].Live) and not(chkAutoContraste.Checked)) then
      begin
        arrCell[i, j].Retangulo.Brush.Color := clBlack;
      end
      else if ((arrCell[i, j].Live = False) and not(chkAutoContraste.Checked)) then
      begin
        arrCell[i, j].Retangulo.Brush.Color := clWhite;
      end
      else if ((arrCell[i, j].Live) and (chkAutoContraste.Checked)) then
      begin
        arrCell[i, j].Retangulo.Brush.Color := clWhite;
      end
      else if ((arrCell[i, j].Live = False) and (chkAutoContraste.Checked)) then
      begin
        arrCell[i, j].Retangulo.Brush.Color := clBlack;
      end;
    end;
  end;
  vGeracao := vGeracao + 1;
  if vGeracao > vGeracaoMaxima then
  begin
    vGeracaoMaxima := vGeracao;
    edtGeracaoMaxima.Text := IntToStr(vGeracaoMaxima);
  end;
  edtGeracao.Text := IntToStr(vGeracao);
end;

function TForm2.GetLivingNeighbors(X, Y: Integer): Integer;
var
  count: Integer;
begin
  count := 0;
  // Check cell on the right.
  if not(X = vSize - 1) then
  begin
    if (arrCell[X + 1, Y].Live) then
    begin
      count := count + 1;
    end;
  end;

  // Check cell on the bottom right.
  if ((not(X = vSize-1)) and (not(Y = vSize-1))) then
  begin
    if (arrCell[X + 1, Y + 1].Live) then
    begin
      count := count + 1;
    end;
  end;

  // Check cell on the bottom.
  if not(Y = vSize-1) then
  begin
    if arrCell[X, Y + 1].Live then
    begin
      count := count + 1;
    end;
  end;

  // Check cell on the bottom left.
  if ((not(X = 0) and (not(Y = vSize-1)))) then
  begin
    if arrCell[X - 1, Y + 1].Live then
    begin
      count := count + 1;
    end;
  end;

  // Check cell on the left.
  if not(X = 0) then
  begin
    if arrCell[X - 1, Y].Live then
    begin
      count := count + 1;
    end;
  end;

  // Check cell on the top left.
  if ((not(X = 0) and (not(Y = 0)))) then
  begin
    if arrCell[X - 1, Y - 1].Live then
    begin
      count := count + 1;
    end;
  end;

  // Check cell on the top.
  if not(Y = 0) then
  begin
    if arrCell[X, Y - 1].Live then
    begin
      count := count + 1;
    end;
  end;

  // Check cell on the top right.
  if ((not(X = vSize-1) and (not(Y = 0)))) then
  begin
    if arrCell[X + 1, Y - 1].Live then
    begin
      count := count + 1;
    end;
  end;

  Result := count;

end;
end.
