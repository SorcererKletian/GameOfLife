unit Cell_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ExtCtrls, Types, Graphics, System.UITypes;
type

 TCell = class
 private
   { private declarations }
   FRetangulo: TShape;
   FPonto: TPoint;
   FPontoX: Integer;
   FPontoY: Integer;
   FLiving: Boolean;
   FContraste: Boolean;


 protected
   { protected declarations }
 public
   { public declarations }
   property Retangulo: TShape read FRetangulo write FRetangulo;
   property Ponto: TPoint read FPonto write FPonto;
   property PontoX: Integer read FPontoX write FPontoX;
   property PontoY: Integer read FPontoY write FPontoY;
   property Live: Boolean read FLiving write FLiving;
   property Contraste: Boolean read FContraste write FContraste;
   constructor Create;
   destructor Destroy;
   procedure PaintLivingCell(Cell: TCell);
 published
   { published declarations }
 end;
implementation


{ TCell }

constructor TCell.Create;
begin
  FPonto := Ponto;
  FRetangulo := Retangulo;
  FContraste := False;
  FLiving := False;
end;

destructor TCell.Destroy;
begin
  inherited;
end;

procedure TCell.PaintLivingCell(Cell: TCell);
begin

  if Cell.Retangulo.Brush.Color = clWhite then
  begin
    Cell.Live := False;
  end;

  if Cell.Retangulo.Brush.Color = clBlack then
  begin
    Cell.Live := True;
  end;
end;

end.
