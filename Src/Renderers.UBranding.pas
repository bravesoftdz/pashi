{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2012, Peter Johnson (www.delphidabbler.com).
 *
 * $Rev$
 * $Date$
 *
 * Classes that render either HTML comments or meta generator tags to "brand"
 * output documents as being generated by PasHi.
}


unit Renderers.UBranding;

interface

uses
  Renderers.UTypes;

type
  TBrandingGenerator = class abstract(TInterfacedObject)
  strict private
    var
      fInhibited: Boolean;
  strict protected
    function RenderBranding: string; virtual; abstract;
  public
    constructor Create(Inhibited: Boolean);
    function Render: string;
  end;

type
  TFragmentBrandingRenderer = class sealed(TBrandingGenerator, IRenderer)
  strict protected
    function RenderBranding: string; override;
  end;

type
  TMetaBrandingRenderer = class abstract(TBrandingGenerator)
  strict protected
    function RenderBranding: string; override; final;
    function TagCloser: string; virtual; abstract;
  end;

type
  TNewMetaBrandingRenderer = class sealed(TMetaBrandingRenderer, IRenderer)
  strict protected
    function TagCloser: string; override;
  end;

type
  TOldMetaBrandingRenderer = class sealed(TMetaBrandingRenderer, IRenderer)
  strict protected
    function TagCloser: string; override;
  end;

implementation

uses
  SysUtils;

{ TBrandingGenerator }

constructor TBrandingGenerator.Create(Inhibited: Boolean);
begin
  inherited Create;
  fInhibited := Inhibited;
end;

function TBrandingGenerator.Render: string;
begin
  if fInhibited then
    Exit('');
  Result := RenderBranding;
end;

{ TFragmentBrandingRenderer }

function TFragmentBrandingRenderer.RenderBranding: string;
resourcestring
  sCommentText = 'Highlighted Pascal code generated by DelphiDabbler PasHi';
begin
  Result := Format('<!-- %s -->', [sCommentText]);
end;

{ TMetaBrandingRenderer }

function TMetaBrandingRenderer.RenderBranding: string;
begin
  Result := '<meta name="generator" content="DelphiDabbler PasHi"' + TagCloser;
end;

{ TNewMetaBrandingRenderer }

function TNewMetaBrandingRenderer.TagCloser: string;
begin
  Result := ' />';
end;

{ TOldMetaBrandingRenderer }

function TOldMetaBrandingRenderer.TagCloser: string;
begin
  Result := '>';
end;

end.
