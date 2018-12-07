program Game_of_life;

uses
  Vcl.Forms,
  Main_u in 'Main_u.pas' {Form2},
  Cell_u in 'Cell_u.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
