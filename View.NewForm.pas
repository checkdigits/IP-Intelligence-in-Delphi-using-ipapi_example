//---------------------------------------------------------------------------

// This software is Copyright (c) 2021 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit View.NewForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  View.Main, FMX.Effects, FMX.Layouts, FMX.Ani, FMX.Objects,
  FMX.Controls.Presentation, FMX.Edit, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, System.JSON;

type
  TNewFormFrame = class(TMainFrame)
    Lyt: TLayout;
    EdtIP: TEdit;
    BtnCheckIP: TButton;
    LytCoord: TLayout;
    LblLatitude: TLabel;
    LblLongitude: TLabel;
    LytIPLocationFlag: TLayout;
    LblIPLocation: TLabel;
    LytCityZipCode: TLayout;
    LblCity: TLabel;
    LblZipCode: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    EdtAccKey: TEdit;
    procedure BtnCheckIPClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TNewFormFrame.BtnCheckIPClick(Sender: TObject);
begin
  inherited;
  RESTClient1.ResetToDefaults;
  RESTClient1.Accept := 'application/json';
  RESTClient1.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient1.BaseURL := Format('http://api.ipapi.com/api/%s', [EdtIP.Text]);
  RESTResponse1.ContentType := 'application/json';

  RESTRequest1.Resource := Format('?access_key=%s', [EdtAccKey.Text]);
  RESTRequest1.Execute;

  var JSONValue := TJSONObject.ParseJSONValue(RESTResponse1.Content);
  try
    if JSONValue is TJSONObject then
    begin
      LblLatitude.Text := 'Lat: ' + JSONValue.GetValue<String>('latitude');
      LblLongitude.Text := 'Lon: ' + JSONValue.GetValue<String>('longitude');
      LblIPLocation.Text := 'Location: ' + JSONValue.GetValue<String>('country_name');
      LblCity.Text := 'City: ' + JSONValue.GetValue<String>('city');
      LblZipCode.Text := 'Zip Code: ' + JSONValue.GetValue<String>('zip');
    end;
  finally
    JSONValue.Free;
  end;
end;

initialization
  // Register frame
  RegisterClass(TNewFormFrame);
finalization
  // Unregister frame
  UnRegisterClass(TNewFormFrame);

end.
