unit FH;

interface
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
uses
  Messages, SysUtils, Classes, Controls, StdCtrls, ExtCtrls, Jpeg, Windows, Graphics, Dialogs, Forms, DB, DBGrids,
  ShellAPI, Menus, ComCtrls, DateUtils, StrUtils, Math, DbClient, SqlTimSt, Consts, CheckLst, TlHelp32, Spin, Buttons,
  Grids, Variants, FileCtrl, Mask, DBCtrls, CommCtrl, ValEdit, ComObj, Registry, UrlMon, Clipbrd, typInfo,
  IDStackWindows, Vcl.Imaging.pngimage, winsock, soap.EncdDecd;

const
  EMPTY_STR       = '';
  UM_ESPACO       = ' ';
  DOIS_ESPACOS    = UM_ESPACO + UM_ESPACO;
  VIRGULA         = ',';
  VIRGULA_ESPACO  = ', ';
  TAB             = #9;
  CRLF            = #13#10;
  DCRLF           = CRLF + CRLF;
  ASPAS_SIMPLES   = #39;
  ASPAS_DUPLAS    = #34;
  HEX_CRLF        = #$D#$A;
  HEX_CRETURN     = #$D;
  HEX_LINEFEED    = #$A;
  STRBR           = '<BR>';

  DIASEM_SEGUNDA  = 1;
  DIASEM_TERCA    = 2;
  DIASEM_QUARTA   = 3;
  DIASEM_QUINTA   = 4;
  DIASEM_SEXTA    = 5;
  DIASEM_SABADO   = 6;
  DIASEM_DOMINGO  = 7;

  MSG_DEFAULT_VALIDACAO = 'Conteúdo inválido ou não informado.';
  MSG_FALTA_PARAMETROS  = 'Nenhum parâmetro para consulta informado.';

  COD_MUNICIPIO_CAXIAS      = 4305108;
  COD_MUNICIPIO_FARROUPILHA = 4307906;
  COD_MUNICIPIO_TAQUARI     = 4321303;

var
  vrgRoot             : string = 'pressier';
  vrgSubRoot          : string = 'ERP';
  vrgDefErrMsg        : string = MSG_DEFAULT_VALIDACAO;
  vrgHKeyDefault1     : HKEY = HKEY_USERS;
  vrgHKeyDefault2     : HKEY = HKEY_CURRENT_USER;
  vrgDefaultDir       : string = 'sis\';
  vrgDirCache         : string = 'Sel';

// Constantes de Sistema
function SeparadorData: Char;
function SeparadorMilhar: Char;
function SeparadorDecimal: Char;
function FormatoDataPadrao: string;
procedure SetaFormatoDataPadrao(const AFormato: string);

//  PDirecao -> indica o lado do preenchimento: -1 à esquerda, 0 no centro e 1 à direita
function PreencheStr(const PDirecao: Shortint; const S: string; const PTam: SmallInt; const PChr: string = #32): string; overload;
//    Preenche uma string com um determinado símbolo à esquerda.
//    Se o tamanho da string for maior que PTam a string será truncada.
function PreencheStr(const S: string; const PTam: SmallInt; const PChr: string = #32): string; overload;
//    Preenche uma string com brancos à direita
function PreencheDir(const S: string; const PTam: SmallInt): string;
//    Preenche uma string com brancos à esquerda
function PreencheEsq(const S: string; const PTam: SmallInt): string;
//    Preenche uma string com zeros à esquerda
function StrZero(const S: string; const PTam: SmallInt): string; overload;
function StrZero(const N: integer; const PTam: SmallInt): string; overload;
//  Completa uma string com um símbolo. É diferente de PreencheStr porque
//  esta função não trunca a string se ela for maior que PTam
procedure PadR(var PString: string; const PTam: integer; const PChr: string = ' ');
procedure PadL(var PString: string; const PTam: integer; const PChr: string = ' ');
//    Conta as ocorrências de PSubStr dentro de S
function ContaStr(S, PSubStr: string; PIndex, PTotal: integer): integer; overload;
function ContaStr(S, PSubStr: string): integer; overload;
function TrimX(const S: string; A: string): string;
//     Retorna a parte inteira de uma string
function StrInteiro(pNumero: string): string;
//     Remove os zeros à esquerda da string
function LimpaZero(Texto: string): string;
function Espacos(PTam: integer): string;
function LimpaChrEspecial(Str: string): string;
function LimpaAaZ(PStr: string): string;
function LimpaAspas(const S: string): string;
function RetCodigoStr(const S: string; const PSep: string = ' '): string;
function RetDescriStr(const S: string; const PSep: string = ' '): string;
//    gera uma lista de strings a partir de uma string simples com o seguinte formato: S1,S2,S3,..,Sn
procedure StrParaLista(const POrigem: string; var PDestino: TStrings);
function ListaParaStr(ALista: TStrings): string;
function CarregaSeExiste(var L: TStrings; const pArq: string): Boolean;
procedure InsereNaLista(Lista: TStrings; const Linhas: string; const TextoPlano: Boolean = True; const RemoverAspas: Boolean = false);
procedure FormaLista(var V: string; const S: string; const Espacado: Boolean = True; const ComQuebras: Boolean = False; const PontoEVirgula: Boolean = False);
function FormaListaStr(const strResultante, strAdicionar: string; const Espacado: Boolean = True): string;
function TemAaZ(const PStr: string): Boolean;
function SeStrVazia(const PStr, PDefault: string): string;
function TemInteiro(const PStr: string): Boolean;
function NaoTemInteiro(const PStr: string): Boolean;
function CopyInvertido(S: string; Index, Count: integer): string;
function ValidaIdentificador(const Nome: string): Boolean;

function EntrePar(const PStr: string; const PEspacos: smallint = 0): string;
function FonteParaStr(const F: TFont; const FlatString: Boolean = False): string;
function StrParaFonte(const S: string; PDefault: TFont; const FlatString: Boolean = False): TFont;
procedure CriaLista(var L: TStrings; const pTexto: string = '');
procedure GravaLista(var L: TStrings; const Arquivo: string);
function LimpaString(const S: string; PChr: array of string): string;
function LimpaTagsHTML(const S: string): string;
function LimpaEspacos(const S: string): string;
function LimpaPonto(const S: string): string;
function LimpaVirgula(const S: string): string;
function LimpaChrNaoImprimiveis(const ATexto: string): string;
function ArrayTemValor(const AArray: array of string): Boolean;
// Limpa os nulos (#0) de um arquivo texto
procedure LimpaNulosArquivo(const pArquivo: String);
// Elimina todos "#$D#$A" em uma string
function LimpaQuebras(const S: string; const PSubChar: string = ' '): string;
function LimpaQuebrasTrim(const S: string): string;
function TrimQuebras(const S: string): string;
function InsereAspasLista(const S: string): string;
function GetCampoCsv(const ALinha: string; const APosicao: Integer): string;

//     Substitui/insere as quebras no texto.
type
    TTipoSubstituicaoQuebra = (BreakParaStr, StrParaBreak);
function SubstituiQuebras(const pTexto: string; const Tipo: TTipoSubstituicaoQuebra): string; overload;
//     pTrocar = true  : substitui a quebra '#$D#$A' pelo '<BR>'
//     pTrocar = false : substitui o '<BR>' pela quebra '#$D#$A'
function SubstituiQuebras(const pTexto: string; const pTrocar: Boolean): string; overload;
// Remove os pontos de uma string e a converte para numérico
// Se S não for um valor válido então será devolvido PDefault
// Se PDefault for igual a 3.4e-4932 (MinExtended) e S for inválido então
// uma exceção será disparada
function StrParaNum(const S: string; PDefault: Extended = MinExtended): Extended;
function CopyPos(const PStr, PSubStr: string; const PTrim: Boolean = true): string;
//     Funciona como um Copy(PStr, PIndex, Length(PStr) - PTotal)
//     Ou seja, quanto maior for PTotal menor será o resultado
function CopyMin(const PStr: string; const PTotal: integer; const PIndex: integer = 1): string;
function CopyPosMax(const PStr, PSubStr: string; const PTrim: Boolean = true): string;
function CopyPosSeContem(const PStr, PSubStr: string; const PTrim: Boolean = true): string;

function CopyEntre(const PStr, PTagIni, PTagFin: string; const PTrim: Boolean = true): string;
//     Faz uma comparação 'case-insensitive' entre PVar e PFixo
//     PVar é ajustada para não ser maior que PFixo
function ComparaTextoFixo(const PVar, PFixo: string): Boolean;
function StrParecida(const S1, S2: string): Boolean;
function MontaReplaceLimpaSQL(const PCampo: string; PSimbolos: array of string): string;
function MontaReplaceLimpaSQLInt(const PCampo: string): string;
function MontaFmtDataPadraoSQL(const ACampo: string): string;
function MultiStringReplace(const S: string; const OldPattern, NewPattern: array of string;
  Flags: TReplaceFlags): string;
//  Substitui a função SysUtils.StrScan que exige parâmetros PChar
//  PInit indica em que ponto da string de resultado será copiado
//  o resultado final. Por padrão é 1, ou seja, será repassado o resultado
//  da função SysUtils.StrScan na íntegra, senão será como
//  um Copy(Resultado, PInit, 2147483647)
function StrScan(const PStr: string; Chr: AnsiChar; PInit: integer = 1): string;
procedure CopiaParaAreaTransf(const S: string);
procedure GeraArqTexto(const pNomeArq, pTexto: string);
function DeletaLinhasEmBranco(const pLinhas: string): string;
function FmtNum(pVal: Extended; pDec: Byte = 2): string;
function FmtFix(pVal: Extended; pDec: Byte = 2): string;
function FmtNumStr(pVal: string; pDec: Byte = 2; PDefault: Extended = 0): string;
function FmtFixStr(pVal: string; pDec: Byte = 2; PDefault: Extended = 0): string;
function FmtInt(pVal: int64): string;
//     gera uma string formatada com zeros à esquerda, útil para exportações para
//     arquivo texto
function FmtFloatStr(pVal: Extended; PTamString: integer; pDec: Byte = 2): string; overload;
function FmtFloatStr(pVal: string; PTamString: integer; pDec: Byte = 2): string; overload;
function FmtNumParaFix(pVal: string; pDec: Byte = 2; PDefault: Extended = 0): string;
function StrToFloatFix(pVal: string): Extended;
function FmtValSQL(pVal: Extended): string;
function Concatenar(PStrings: array of string; const PSeparador: string; const PDistintos: Boolean = False): string;
//    Funciona como um Pos "Case-Insensitive"
function PosStr(Substr, Str: string): integer;
function StrInvalida(const S: string): Boolean;
function StrOk(const S: string; const RemoverQuebras: Boolean = false): Boolean;
function StringListOk(SL: TStrings): Boolean;
function RetMaskNum(const PQtdDec: integer; const PPrefixo: string = '###,###,##0.'): string;
function RetMaskQtd(const PQtdDec: integer; const PPrefixo: string = '###,###,##0.'): string;
//     Retorna um valor escrito por extenso em formato monetário
function RetValorExtenso(AValor: double; const AEntreAsteriscos: Boolean = False; const AMonetario: Boolean = True;
                                         const AFeminino: Boolean = False; const ASeparadorFracao: string = 'e'): string;
//     Retorna um código formatado conforme a máscara do CNPJ/CPF
//        CPF  = 999.999.999-99
//        CNPJ = 99.999.999/9999-99
function FormataCNPJCPF(const PCode: string): string;
//   Retorna um código formatado conforme a máscara do CNPJ/CPF
//        CPF  = 999999999-99
//        CNPJ = 99.999.999/9999-99
function MontaCNPJCPF(const Codigo: string): string;
//     Torna maiúscula toda a string pTexto ou somente uma parte dela
//     quando a PTotal for maior que zero
function SetaUpper(const pTexto: string; const PTotal: integer = -1): string;
function InTags(const Tags, Valor: string): Boolean;
procedure MontaTags(var Tags: string; const Valor: string); overload;
procedure MontaTags(var Tags: string; DS: TDataSet; const Campo: string; const Exclusivo: Boolean = False); overload;
function ListaStrParaTags(const StrLista: string): string;
//     Retorna um determinado número de palavras da string passada
function RetPalavra(const S: string; const PQuant: integer): string;
function RetNivelAnterior(const S: string): string;
function RetNivel(const S: string): Integer;
function RetNivelMaior(const S: string): Integer;
procedure IniGera(var L: TStrings; const PConteudo: string);
procedure IniGrava(var L: TStrings; const pNomeArq: string);
procedure IniDeletaSec(var L: TStrings; const PSecao: string);
procedure IniDeletaIdent(var L: TStrings; const PSecao, PIdent: string);
function IniExisteSec(var L: TStrings; const PSecao: string): Boolean;
procedure IniGravaStr(var SL: TStrings; const PSecao, PIdent, pValor: string);
procedure IniGravaInt(var L: TStrings; const PSecao, PIdent: string; const pValor: integer);
procedure IniGravaNum(var L: TStrings; const PSecao, PIdent: string; const pValor: Extended);
procedure IniGravaBln(var L: TStrings; const PSecao, PIdent: string; const pValor: Boolean);
procedure IniGravaData(var L: TStrings; const PSecao, PIdent: string; const pValor: TDateTime);
function IniLeStr(var L: TStrings; const PSecao, PIdent: string; const PDefault: string = ''): string;
function IniLeInt(var L: TStrings; const PSecao, PIdent: string; const PDefault: integer): integer;
function IniLeNum(var L: TStrings; const PSecao, PIdent: string; const PDefault: Extended): Extended;
function IniLeBln(var L: TStrings; const PSecao, PIdent: string; const PDefault: Boolean): Boolean;
function IniLeData(var L: TStrings; const PSecao, PIdent: string; const PDefault: TDateTime): TDateTime;

function FloatParaHoraStr(const PValor: Extended): string; overload;
function FloatParaHoraStr(const PValor: string): string; overload;
function HoraStrParaFloat(const PValor: string): Extended;
function MontaHoraValida(const SHoras: string): string;
function MenorQueZero(const v: Extended): Boolean;
function MaiorQueZero(const v: Extended; const Decimais: Smallint = 2): Boolean;
function SeMaiorqueZero(const PVal, PDefault: Extended; const Decimais: Smallint = 2): Extended;
//  retorna o índice se algum dos valores passado pelo vetor PValores está contido ou é
//  igual ao parâmetro pTexto. O teste é 'case-insensitive'
function ContemTextoIndex(const pTexto: string; const PValores: array of string): integer;
//    verifica se algum dos valores passado pelo vetor PValores está contido ou é
//    igual ao parâmetro pTexto. O teste é 'case-insensitive'
function ContemTexto(const pTexto: string; const PValores: array of string): Boolean;
function Match(const pTexto: string; const pValores: array of string): Boolean; overload;
function Match(const pNumero: Integer; const pValores: array of Integer): Boolean; overload;
function Contem(const pTexto, pSubtexto: string): Boolean; overload;
function Contem(const pTexto: string; const pSubtextos: array of string): Boolean; overload;
function NaoContem(const pTexto, pSubtexto: string): Boolean;
function Same(const S1, S2: string): Boolean;
function NotSame(const S1, S2: string): Boolean;
function PreparaValorValido(const PStr: string; const pDec: SmallInt; const PSepMilhar: Boolean): string;
function BoolParaStr(const pValor: Boolean): string;
function StrParaBool(const pValor: string; const PDefault: Boolean = false): Boolean;
function SeTemInteiro(const PStr: string; const SenaoRetorne: string = ''): string;
function PreparaLike(const PStr: string; const PInicio: Boolean = True; const PFinal: Boolean = True): string;
function WhereAnd(const PSql: string; const PVerificarApos: string = ''; const PVerificarAte: string = ''): string;
function AdicionaQuebra(const pTexto: string): string;
procedure AdicionaLinha(var S: string; const Linha: string; const Quebras: Integer = 1);
function RetCodigoCombo(CB: TComboBox; const PCodigos: array of string; const PNaoSel: string = ''): string;
//    retorna o valor de uma determinada posição do array Valores
//    é util para retornar valores de um combo, lista etc...
//    ex.: situação [itens         : |TODOS|OK  |Cancelado|Estornado|
//                   corresponde a : |''   |'OK'|'CA'     |'ES'     |]
//         poupa de fazer um "case" testando índice por índice para
//         fazer, por ex., um script sql
function RetValIndex(const Index: integer; const Valores: array of string; const Quoted: Boolean = false): string;
function CaseOf(const Valor: string; const IDs, Results: array of string): string;
//  muda uma string para o formato de nome próprio
function ProperCase(PStr: string): string;
function SentenceCase(const pStr: string; const pTrim: Boolean = True): string;
function Reticencias(PStr: string; const PTam: Integer): string;
function StrParaVar(const PStr: string): Variant;
function VarTemConteudo(const V: Variant): Boolean;
function VarParaStr(const V: Variant): string;
function ContaPalavra(const PStr: string): Integer;
procedure PreparaPChar(var P: PChar; const Org: string; const TamanhoMaximo, TamAloca: Cardinal);
procedure PreparaPAnsiChar(var P: PAnsiChar; const Org: string; const TamanhoMaximo, TamAloca: Cardinal);
function RandomString(const TamanhoMaximo: Integer; const Completar: Boolean): string;
function EmailOK(const AEmail: string; AMetodoRFC: Boolean = False): Boolean;
function GetXMLTag(const Tag, Texto: string): string;
function SetXMLTag(const Tag, Texto: string): string;
function GetXMLTagAtrib(const Tag, Campo, Texto: string): string;
function SetXMLFloat(const ValorStr: string): Double;
function XMLTagExiste(const Tag, Texto: string): Boolean;
function SeTemConteudo(const Texto, TxIni, TxFin: string): string;

function AjustaChrHTML(const Texto: string): string;
function AjustaChrEspecial(const Texto: string): string;
function AjustaChrUTF8(const Texto: string): string;

function MontaListaValores(const Valores: array of string): string; overload;
function MontaListaValores(const Valores: TStrings): string; overload;

function StringToHex(const S: string): string;
function DataXMLParaDataPadrao(const pData: string): string;
function SetaPrimeiraLetraMaiuscula(const pTexto: string): string; overload;
procedure SetaPrimeiraLetraMaiuscula(const Texto: string; var Key: Char); overload;
procedure SetaPrimeiraLetraMaiuscula(const Edit: TCustomEdit; var Key: Char); overload;
function MemoryStreamParaString(M: TMemoryStream): string;
procedure StrParaStream(const Stream: TStream; Value: AnsiString);
function EntreAspas(const S: string): string;
function EncodeURL(const Value: AnsiString): AnsiString;

//-------------------------------------------------------------------------------------------------------------------
function DataOk(const S: string): Boolean;
function DatasOk(const D1, D2: string): Boolean;
function DataHoraOk(const S: string): Boolean;
function DataInvalida(const S: string): Boolean;
function SemData( const Data1, Data2 : string ) : Boolean ;
//     Assegura que a string S seja uma data válida
function TrataData(const S: string; PDef: string = ''): string;
//     Assegura que a string S seja uma data/hora válida
function TrataDataHora(const S: string; PDef: string = ''): string;
function HoraOk(const S: string): Boolean;
//     Assegura que a string S seja uma hora válida
function TrataHora(const S: string; PDef: string = ''): string;
function RetDataExtenso(PStrData: string; PDiaPorExtenso: Boolean): string;
function FmtDataDDMMAA(const PData: string): string;
function FmtDataDDMMAAHHMM(const PDataHora: string): string;
function MaxDate(const A, B: TDateTime): TDateTime;
function MinDate(const A, B: TDateTime): TDateTime;
function RetDiaSemanaExtenso(PData: TDateTime; const MostrarFeira: Boolean = True): string; overload;
function RetDiaSemanaExtenso(const PDia: integer): string; overload;
function VerSabadoOuDomingo(PData: TDatetime): Boolean;
function DiaUtil(PData: TDatetime): Boolean;
function DiaUtilProximo(PData: TDatetime): TDatetime;
function DiaUtilAnterior(PData: TDatetime): TDateTime;
function TotalDiasUteis(PData: string; const ConsideraSabados: Boolean): Integer;
function RetNomeMes(const PMes: integer; const PDisplayFormat: string = 'mmmm'): string;
function DataSqlDefault(PStrData: string): string; overload;
function DataSqlDefault(PData: TDateTime): string; overload;
function DataSqlMDA(PStrData: string): string;
function RetDataArquivo(const pNome: string): TDateTime;
function ConverteDDMMAAParaData(const PData: string): string;
function IncDiaUtil(const PData: TDateTime; const PNroDias: Integer): TDateTime;

//     verifica a formatação de datas do windows
procedure VerificaFmtDataWindows;
function HojeStr: string;
function HoraStr(const PHora: TTime = 1): string; overload;
function HoraStr(const PHora: string): string; overload;
//    retorna a hora atual em formato hh:mm
function NowStr: string;
function TimeStamp: string;
function TimeStampString: string;
//     Retorna a hora atual em string no formato hh:mm:ss
function HoraExata: string;
//     Retorna o mês/ano da data passada. Se não for informada a data na versão
//     com parâmetro TDateTime será considerada a data atual
function GetMesAno(const PData: TDateTime = 0): string; overload;
function GetMesAno(const PData: string): string; overload;
//     Retorna o ano/mês da data passada. Se não for informada a data na versão
//     com parâmetro TDateTime será considerada a data atual
function GetAnoMes(const PData: TDateTime = 0): string; overload;
function GetAnoMes(const PData: string): string; overload;
//     Codifica uma data conforme o MesAno passado (ex.: '10/2003'). Se PDia for
//     -1 então será atribuído o último dia do mês correspondente
function MontaDataMesAno(const PMesAno: string; const PDia: Smallint = 1): TDateTime;
function MontaDataStrMesAno(const PMesAno: string; const PDia: Smallint = 1): string;
function MontaMesAnoExtenso(const DataOuMesAno: string; const AnoComDoisDigitos: Boolean = false): string;
function InverteMesAno(const PMesAno: string; const SemBarra: Boolean = False): string;
function InverteAnoMes(const PAnoMes: string): string;
// passar nos formatos dd/mm ou mm/dd
function InverteDiaMes(const PDiaMes_OU_MesDia: string): string;
function IncMesAno(const PMesAno: string; const Incremento: Integer): string;
function IncAnoMes(const PAnoMes: string; const Incremento: Integer): string;
function MesAnoValido(const pValor: string): Boolean;
function AnoMesValido(const pValor: string): Boolean;
//     Retorna o mês da data (TDateTime ou String) em formato string
function RetMesStr(const PData: TDateTime = 0): string; overload;
function RetMesStr(const PData: string): string; overload;
function DiaAtual: integer;
function MesAtual: integer;
function AnoAtual: integer;
function AnoAtualStr: string;
function UltimoDiaAnoStr(const D: TDateTime): string;
function PrimeiroDiaAnoStr(const D: TDateTime): string;
function MesAtualStr: string;
function DiaAtualStr: string;
function Coalesce(const Valores: array of string): string;
//    converte um número em milisegundos para um padrão de hora válido
function FmtMilesimos(const Z: int64; const MostraMilesimos: Boolean = True; const MostraSegundos: Boolean = True): string;
//    converte um número em milisegundos para um padrão de hora válido
function FmtMinutos(const Z: int64; const MostraSegundos: Boolean = False): string;
// converte um número a diferença de milisegundos para um padrão de hora válido
// esta função diminui o resultado de GetTickCount do parâmetro BaseZ, ou
// seja, ela retorna a diferença entre as duas a fim de mostrar um determinado
// espaço de tempo
function MontaHoraDelta(const BaseZ: int64): string;
//    Retorna o AnoMês da data passada. Se não for informada a data na versão
//    com parâmetro TDateTime será considerada a data atual
function RetAnoMesInt(const PData: TDateTime = 0): string; overload
function RetAnoMesInt(const PData: string): string; overload;
function MontaDataAnoMesInt(const PAnoMes: string; const PDia: Smallint = 1): TDateTime;
function MontaDataStrAnoMesInt(const PAnoMes: string; const PDia: Smallint = 1): string;
function UltimoDia(const PData: TDateTime = 0): integer; overload;
function UltimoDia(const PData: string): integer; overload;
function UltimoDia(PAno, PMes: SmallInt): SmallInt; overload;
function PrimeiroDiaMes(const PData: TDateTime = 0): TDateTime;
function PrimeiroDiaMesStr(const PData: TDateTime = 0): string;
function PrimeiroDiaTrimestre(const PData: TDateTime): string;
function UltimoDiaTrimestre(const PData: TDateTime): string;
//     Retorna a data com último dia do mês
function UltimoDiaMes(const PData: TDateTime = 0): TDateTime;
function UltimoDiaMesStr(const PData: TDateTime = 0): string;
//     Codifica uma data a partir da data original cujo formato deve ser informado
function MontaDataFormatada(const PDataOriginal, PDisplayFormat: string): string;
function DataEntre(const PData, PMin, PMax: TDateTime): Boolean;
function TrataMesAno(PMaskEdit: TMaskEdit): Boolean;
function TrataAnoMes(PMaskEdit: TMaskEdit): Boolean;
function PrimeiroDiaMesAno(const PMesAno: string): string;
function UltimoDiaMesAno(const PMesAno: string): string;
//-------------------------------------------------------------------------------------------------------------------
function TruncVal(const V: Extended): Extended;
function IsFloatMaiorQue(PStr: string; PMaiorQue: double): Boolean;
function FloatOk(const S: string): Boolean;
// IntOK é igual a Int64OK
function IntOk(const S: string): Boolean;
function Int64Ok(const S: string): Boolean;
function Int32Ok(const S: string): Boolean;
function IntInvalido(const S: string): Boolean;
function ListaIntOk(const S: string): Boolean;
function ListaStrOk(const S: string): Boolean;
function TrataInt(const S: string; PDef: string = '0'): string;
function ZeroOk(const F: Extended): Boolean;
function ZeroOuMenor(const F: Extended): Boolean;
function NaoZero(const F: Extended): Boolean;
function MultiploOK (const n1, n2: Extended) : Boolean;
function ValoresIdenticos(const PValor1, PValor2: extended; const pDec: Integer = 2): Boolean;
function ValoresDiferentes(const PValor1, PValor2: extended; const pDec: Integer = 2): Boolean;
//Checa se pValor é zero e passa então o PDefault para o resultado
function VerZero(const pValor: Extended; const PDefault: Extended = 1): Extended;
function MaiorQue(const PValor1, PValor2: Extended; const PDelta: Extended = 0): Extended;
//     Faz uma divisão segura evitando a divisão por zero
function SafeDiv(const PDividendo, PDivisor: Extended; const PDivisorDefault: Extended = 1): Extended;
function TrataDivZero(const PDividendo, PDivisor: Extended; const ResultadoQuandoZero: Extended = 0): Extended;
//     Executa Arredondarmento e devolve float
//     Utilizar em somatórios
function ArredondaValor(const pVal: Extended; const PDecimal: integer = 2): Extended;
function ArredondaValorStr(const pVal: Extended; const PDecimal: integer = 2): string;
function CalcPercentual(const PBase, PPercentual: double): double;
//     ex.: Qual seria o imposto sobre R$900,00, considerando a aliquota de 8.75%
//
function CalcPorcentagem(const X, Y: double): double;
//       ex.: Se a população dos EUA é de 250.000.000 de pessoas e a população da
//       California é de 30.000.000, qual a porcentagem do total de pessoas nos
//       EUA que vive na California?
function CalcPorcentagemTotal(const X, Y: double): double;
//   ex.: a população do estado de Nevada era de 800.000 em 1980 e em 1989 era de
//   1.111.000. Qual foi a mudança percentual na população?
function CalcPorcentagemDelta(const X, Y: double): double;
function PorCento(const PValor, PPercentual: Double; const PArredondaDecimal: Smallint = 2): Extended;
function TrataFloat(const S: string; PDef: string = ''): string;
//     Retorna a parte fracionária de um número multiplicada por um pivô
//     Ex.: FracInt => Frac(1.435) => 0.435 * Pivo => 0.435 * 1000 => 435
function PixelParaMm(const pValor: integer): double;
function MmParaPixel(const pValor: double): integer;
function StrToWord(const Value: String): Word;
function WordToStr(const Value: Word): string;
function VarParaFloat(const V: Variant): Extended;
procedure QuickSort(var A: array of Integer);
function TickCountStr: string;
function GetUID(const pTamanho: Integer = -1): string;
function SeSenao(const aValor: Boolean; const aTrue: string; const aFalse: string = ''): string; overload;
function SeSenao(const aValor: Boolean; const aTrue: Integer; const aFalse: Integer = 0): Integer; overload;
function SeSenao(const aValor: Boolean; const aTrue: Extended; const aFalse: Extended = 0): Extended; overload;
function SeSenao(const aValor: Boolean; const aTrue: Int64; const aFalse: Int64 = 0): Int64; overload;
function SeSenao(const aValor: Boolean; const aTrue: Variant; const aFalse: Variant): Variant; overload;
function StrDiferentes(const aStr1, aStr2: string): Boolean;
function SimStr(const aStr: string): Boolean;
function SimNaoExtenso(const aStr: string): string;
//-------------------------------------------------------------------------------------------------------------------
//     Assegura que um delimitador seja incluído no final da string
//     Obs.: é uma abreviação da função IncludeTrailingPathDelimiter
function AdicionaDelimitador(const S: string): string;
//     Inclui uma extensão no arquivo passado
function AdicionaExtensao(const S, PExt: string): string;
function RemoveExtensao(const S: string): string;
//abre o arquivo passado em F com o seu respectivo programa
function ChamaExec(const F: string; FR: TForm): string;
procedure ExecutaArquivo(const F: string; FR: TForm = nil);
function DuplicaArquivo(const ArqOrg, ArqDst: string; const ASobrepor: Boolean = false): Boolean;
//     Rertorna o diretorio para criacao de arquivos temporarios
//  Resultado: '<unidade>:\<diretório_da_aplicação>\<dir_especificado>\'
function SetaLocal(const PDir: string): string;
function SetaLocalTmp: string;
function RetDirSis: string;
function TerminaProcesso(PNomeExe: string): integer;
function ProcessoRodando(PNomeExe: string): Boolean;
function ContaProcessosRodando(PNomeExe: string): integer;
function BlockInput(fBlockIt: Boolean): Boolean;
//     Delete múltiplos arquivos de um diretório conforme a máscara PMask
procedure DeletaArquivoComMascara(FR: TForm; const PDir, PMask: string);
function RenomeiaArquivo(const PDirArqOrigem, PDirArqDestino: string): Boolean;
function MoveArquivo(const POrigem, PDestino: string): Boolean;
function RetConteudoArquivo(const PArquivo: string): string;
function RetTamanhoArquivo(const PArquivo: string): Integer;
function RetTamanhoArquivoBytes(const PArquivo: string): Int64;
//  ajusta o nome do arquivo para um padrão válido no windows
function SetaNomeValidoArquivo(const pNomeArq: string): string;
//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistry(const pKey, pNome, PConteudo: string; const PSubKeys: string = '');
procedure GravaRegistryGeral(pKey, pNome, PConteudo: string);
procedure GravaRegistryStr(pKey: TForm; pNome, PConteudo: string); overload;
procedure GravaRegistryStr(pKey, pNome, PConteudo: string); overload;
procedure GravaRegistryInt(pKey: TForm; pNome: string; PConteudo: integer); overload;
procedure GravaRegistryInt(pKey, pNome: string; PConteudo: integer); overload;
procedure GravaRegistryBool(pKey: TForm; pNome: string; PConteudo: Boolean); overload;
procedure GravaRegistryBool(pKey, pNome: string; PConteudo: Boolean); overload;
procedure GravaRegistryReal(pKey: TForm; pNome: string; PConteudo: Extended); overload;
procedure GravaRegistryReal(pKey, pNome: string; PConteudo: Extended); overload;
procedure GravaRegistryDate(pKey: TForm; pNome: string; PConteudo: TDateTime); overload;
procedure GravaRegistryDate(pKey, pNome: string; PConteudo: TDateTime); overload;
function LeRegistry(const pKey, pNome: string; const PSubKeys: string = ''): string;
function LeRegistryGeral(pKey, pNome: string): string;
function LeRegistryStr(pKey: TForm; pNome: string; PDef: string = ''): string; overload;
function LeRegistryStr(pKey, pNome: string; PDef: string = ''): string; overload;
function LeRegistryInt(pKey: TForm; pNome: string; PDef: integer = 0): integer; overload;
function LeRegistryInt(pKey, pNome: string; PDef: integer = 0): integer; overload;
function LeRegistryBool(pKey: TForm; pNome: string; PDef: Boolean = false): Boolean; overload;
function LeRegistryBool(pKey, pNome: string; PDef: Boolean = false): Boolean; overload;
function LeRegistryReal(pKey: TForm; pNome: string; PDef: Extended = 0): Extended; overload;
function LeRegistryReal(pKey, pNome: string; PDef: Extended = 0): Extended; overload;
function LeRegistryDate(pKey: TForm; pNome: string; PDef: TDateTime = 0): TDateTime; overload;
function LeRegistryDate(pKey, pNome: string; PDef: TDateTime = 0): TDateTime; overload;
//     exclui os valores de uma chave do registry
//     Se PLimpaTudo for false será considerado o parâmetro pVal que especifica
//     um valor de seqüência da chave passada
function LimpaRegistry(pKey: string; PLimpaTudo: Boolean; pVal: string = ''; const PSubKeys: string = ''): Boolean;
procedure CarregaRegistry(pKey: string; Lista: TStrings; const PSubKeys: string = ''; const CarregaKeys: Boolean = False);

//  Escreve um valor qualquer no canvas especificado obedecendo a um alinhamento
//  específico. Para escrever em um dbgrid use DrawText uma vez que
//  DsnCanvas é de baixo nível
procedure DsnCanvas(PCanvas: TCanvas; PRect: TRect; DX, DY: integer; const PStr: string; PAlinhamento: TAlignment);
//     Modifica a fonte e o preenchimento de uma célula do DBGrid.
//     Isto inclui estilo e cor da fonte e cor do preechimento
procedure GridDsnCel(GR: TDBGrid; const R: TRect; DataCol: integer; PColuna: TColumn;
  PState: TGridDrawState; PCorFonte, PCorBrush: TColor; PEstiloFonte: TFontStyles;
  PVerificaFoco: Boolean = true; PCorSelecionada: TColor = clHighlightText);
//     Escreve uma string qualquer em uma célula do StringGrid. A cor e a fonte
//     são preservadas. PAlinhamento é: -1 à esquerda, 0 ao centro e 1 à direita
procedure StringGridDsnStr(SG: TStringGrid; const R: TRect; PAlinhamento: integer; const PStr: string);
function GetColunaDBGrid(GR: TDBGrid; const PNomeCampo: string): TColumn;
function CorClara(PCor: TColor): Boolean;
//-------------------------------------------------------------------------------------------------------------------
function ArrayPos(PArray: array of Boolean; pValor: Boolean): integer; overload;
function ArrayPos(PArray: array of double; pValor: double): integer; overload;
function ArrayPos(PArray: array of integer; pValor: integer): integer; overload;
function ArrayPos(PArray: array of string; pValor: string): integer; overload;
procedure LimpaArray(PArray: array of string; pValor: string = ''); overload;
procedure LimpaArray(PArray: array of integer; pValor: integer = 0); overload;
procedure LimpaArray(PArray: array of double; pValor: double = 0); overload;
//-------------------------------------------------------------------------------------------------------------------
function MsgBox(const pTexto, PCaption: string; AFlags: Longint = 0): integer;
procedure MsgA(const S: string); overload;
procedure MsgA(const S: string; const Args: array of const); overload;
procedure MsgE(const S: string); overload;
procedure MsgE(const S: string; const Args: array of const); overload;
procedure MsgI(const S: string); overload;
procedure MsgI(const S: string; const Args: array of const); overload;
{ PFlag é um ícone que pode ser:
    0 : questão
    1 : erro
    2 : atenção
    3 : informação }
type
  TFlagMsgSN = 0..3;
function MsgSN(const S: string; PFlag: TFlagMsgSN = 0): integer; overload;
function MsgSN(const S: string; const Args: array of const; PFlag: TFlagMsgSN = 0): integer; overload;
procedure PrMsg_AT(const S: string; const pNegrito: Boolean = False; const pMonoEspacada: Boolean = False); overload;
procedure PrMsg_AT(const S: string; const Args: array of const; const pNegrito: Boolean = False; const pMonoEspacada: Boolean = False); overload;
procedure PrMsg_ER(const S: string); overload;
procedure PrMsg_ER(const S: string; const Args: array of const); overload;
procedure PrMsg_IN(const S: string; const pNegrito: Boolean = False; const pMonoEspacada: Boolean = False); overload;
procedure PrMsg_IN(const S: string; const Args: array of const; const pNegrito: Boolean = False; const pMonoEspacada: Boolean = False); overload;
function  PrMsg_CF(const S: string; PFlag: TFlagMsgSN = 0; const pFocoBotaoSim: Boolean = True): integer; overload;
function  PrMsg_CF(const S: string; const Args: array of const; PFlag: TFlagMsgSN = 0; const pFocoBotaoSim: Boolean = True): integer; overload;
function  PrMsg_Focalize(pCampo: TWinControl; const PMsg: string = ''; const MostrarNomeDoCampo: Boolean = false): Boolean;
function  PrMsg_FocalizeSe(const PCondicao: Boolean; pCampo: TWinControl; const PMsg: string = ''; const MostrarNomeDoCampo: Boolean = false): Boolean;
function  BuscaTreeNode(PTreeView: TTreeView; S: string; PBuscaParcial: Boolean; PExpandir: Boolean = true): TTreeNode;
procedure SetaStatusCheckListBox(PStatus: Boolean; CB: TCheckListBox);
procedure SetaStatusListView(PStatus: Boolean; LV: TListView);
procedure SetaCheckedNegrito(PCheckBox: TCheckBox);
procedure SetaTamanhoForm(FR1, FR2: TForm);
function VerTagBtn(C: TComponent): Boolean;
procedure InverteTagBtn(C: TComponent);
procedure SetaTagBtn(C: TComponent; Ativado: Boolean);
function SetaMensagemValidacao(const ANomeCampo: string; const AMensagemPadrao: string = ''): string;

const
     vmStr = 0;
     vmInt = 1;
     vmNum = 2;
     vmDat = 3;
function ValidaCampo(pCampo: TControl; PTipoCampo: Integer = vmStr; const PDisparaMsg: Boolean = true;
                             const MostrarNomeDoCampo: Boolean = false): Boolean;
function ValidaMultiCampo(PCampos: array of TControl; PTipoCampo: array of Integer; const PDisparaMsg: Boolean = true;
                                   const MostrarNomeDoCampo: Boolean = false): Boolean;

function VerificaEntradaArq(const pNomeArq: string; pCampo: TWinControl): Boolean;
function VerificaEntradaDir(const PNomeDir: string; pCampo: TWinControl): Boolean;
function ValidaCampoInteiro(Campo: TCustomMaskEdit; const Msg: string = 'Código inválido.'): Boolean ;
function ValidaCampoInt64(Campo: TCustomMaskEdit; const Msg: string = 'Código inválido.'): Boolean ;
//  Dispara uma mensagem de erro, envia o foco para o componente passado e
//  muda o cursor da tela para default. Sempre resultará true
//  Se a PMsg não for informada ou for branca será utilizada a mensagem da
//  variável global FH.vrgDefErrMsg
function MsgFocalize(pCampo: TWinControl; const PMsg: string = ''; const MostrarNomeDoCampo: Boolean = false): Boolean;
//     faz a mesma coisa que a função MsgFocalize porém baseada numa condição.
//     Se PCondicao for 'true' executa senão, não faz nada
function MsgFocalizeSe(const PCondicao: Boolean; pCampo: TWinControl; const PMsg: string = ''; const MostrarNomeDoCampo: Boolean = false): Boolean;
procedure SetaComboItemIndex(CB: TComboBox; const PIndex: integer);
// Verifica se um item do checklist passado está marcado
// Se PFullItem = true então será procurado a string pTexto inteira nos itens
// senão, será pego somente até a posição de PDivisor em pTexto
function VerItemCheckListBox(CL: TCheckListBox; const pTexto: string; const PFullItem: Boolean; const PDivisor: string = #32): Boolean;
function VerItemListView(LV: TListView; const pTexto: string): Boolean;
//     Localiza uma string no checklist
//     Se PFullItem = true então será procurado a string pTexto inteira nos itens
//     senão, será pego somente até a posição de PDivisor em pTexto
function BuscaCheckListBox(CL: TCheckListBox; const pTexto: string; const PFullItem: Boolean; const PDivisor: string = #32): Boolean;
//     Verifica se o checklist tem itens selecionados
function VerCheckedCheckListBox(CL: TCheckListBox): Boolean;
//     Verifica se o listview tem itens selecionados
function VerCheckedListView(LV: TListView): Boolean;
//     Verifica se todos os itens do listview estão selecionados
function VerCheckedTodosListView(LV: TListView): Boolean;
function VerCheckedTodosCheckListBox(CL: TCheckListBox): Boolean;
procedure ForceClick(PComp: TControl; PSender: TControl = nil);
procedure ForceExit(PComp: TWinControl; PSender: TWinControl = nil);
//     Dispara um evento sem parâmetros do TControl
procedure ForceEvent(PComp: TControl; PEvento: TNotifyEvent; PSender: TControl = nil);
//     envia o foco para o WC somente se ele pode ser focalizado
function Focalize(WC: TWinControl): Boolean; overload;
function Focalize(AHandle: HWnd): Boolean; overload;
procedure FocalizeProximo(WC: TWinControl);
function FocalizeSe(const PCondicao: Boolean; PWnCtrTrue, PWnCtrFalse: TWinControl): Boolean;
procedure FocalizeFirst(PContainer: TObject);
//     seta o enabled de um conjunto de componentes
procedure SetaEnabled(const AEnabled: Boolean; AComponentes: array of TComponent);
//     seta o enabled de um conjunto de componentes dentro do container
procedure SetaEnabledContainer(PContainer: TWinControl; const PEnabled: Boolean);
//     seta o enabled de um conjunto de componentes conforme um DataSet
procedure SetaEnabledDataSet(DS: TDataSet; PCampos: array of TComponent);
//        Limpa os sub-componentes do container passado
//        Obs.: Labels com Tag 9 = caption nulo
//        Labels com Tag 8 = serão limpas com a procedure SetaCaptionLbl
procedure LimpaContainer(PContainer: TWinControl);
procedure LimpaComponentes(PCampos: array of TControl); overload;
//        Limpa as labels do container passado
//   Obs.: Labels com Tag = 9 ficarão com o caption nulo
//        Labels com Tag = 8 serão limpas com a procedure SetaCaptionLbl
procedure LimpaContainerLabel(PContainer: TWinControl);
procedure BloqUpdate(WC: TWinControl);
procedure DesbloqUpdate;
procedure IncExclusivo(Lista: TStrings; const S: string; const VerificarSemQuebras: Boolean = False); overload;
procedure IncExclusivo(CB: TComboBox; const S: string); overload;
function ProcuraNaLista(Lista: TStrings; const Texto: string): Integer;
function BuscaNaLista(const AListaStr, ATexto: string): Boolean;
function RetornaItemNaLista(const AListaStr: String; AItem: Integer): String;

procedure FmtFloatLabel(var PLabel: TLabel; const pValor: Extended; const PCaption: string = ''; const PThousandSeparator: Boolean = true; const pDec: smallint = 2);
procedure FmtIntLabel(var PLabel: TLabel; const pValor: integer; const PCaption: string = ''; const PThousandSeparator: Boolean = true);
procedure HideFR(FR: TForm);
procedure ShowFR(FR: TForm);
function RetForm(const FR: string): TForm;
function RetFormComp(const FR, PCtr: string): TComponent;
function RetFormControl(const FR, PCtr: string): TControl; overload
function RetFormControl(FR: TForm; const PCtr: string; const PIndex: integer): TControl; overload
function RetFormWinControl(const FR, PCtr: string): TWinControl;
function RetFormEdit(const FR, PCtr: string): TEdit; overload;
function RetFormEdit(FR: TForm; const PCtr: string): TEdit; overload
function RetFormEdit(FR: TForm; const PCtr: string; const PIndex: integer): TEdit; overload
function RetFormButton(const FR, PCtr: string): TButton;
function RetFormLabel(const FR, PCtr: string): TLabel;
function RetFormComboBox(const FR, PCtr: string): TComboBox;
function RetFormMaskEdit(const FR, PCtr: string): TMaskEdit;
function RetFormCds(const FR, PCtr: string): TClientDataSet;
function RetAtvFormComp(const PCtr: string): TComponent;
function RetAtvFormControl(const PCtr: string): TControl;
function RetAtvFormWinControl(const PCtr: string): TWinControl;
function RetAtvFormEdit(const PCtr: string): TEdit;
function VerOwner(FR: TForm; const POwner: string): Boolean;

procedure FreeNil(var PObj); overload;
procedure FreeNil(Objs: array of TObject); overload;

procedure LimpaBufferTeclado(FR: TForm);
procedure LimpaBufferMouse(FR: TForm);
procedure SetaComboDes(CB: TComboBox; S: string; PSep: string = ' ');
procedure SetaComboCod(CB: TComboBox; S: string; PSep: string = ' ');
procedure SetaComboVal(CB: TComboBox; const S: string; const Valores: array of string; const default: Integer = -1);
procedure SetaComboIndex(CB: TComboBox; const S: string; const IndexDefault: Integer = -1);
procedure GravaImagemTab(PC: TPicture; DS: TDataSet; const pCampo: string);
function LeImagemTab(PC: TPicture; DS: TDataSet; const pCampo, PExtensao: string): Int64 ;
function CapturaTela(const PHandleJanela: HWND): TBitmap;
function CapturaTelaJPG(const PHandleJanela: HWND; const AArquivoSaida: string): TJpegImage;
function VerificaCargaArquivo(const PArq: string) : Boolean ;
procedure GravaArqTab(const PArq: string; DS: TDataSet; const pCampo: string);
function GeraArqTab(DS: TDataSet; const pCampo, PDestino: string; const AbreArq: Boolean; const GeraNovoSeExiste: Boolean = True): string;
procedure ChamaPopupMenu(PComponente: TControl; PPopupMenu: TPopupMenu);
procedure CentralizaWinControl(PWc, PContainer: TWinControl; const PVisible: Boolean);
procedure SetaEnabledBotaoSairForm(FR: TForm; const PEstado: Boolean);
function GeraImagemPrintScreen(const AArquivoSaida: string; const AQualidade: TJPEGQualityRange = 100): TJpegImage;
procedure GirarBitmap90Graus(var Bitmap: TBitmap);
//-------------------------------------------------------------------------------------------------------------------
function VerificaCNPJ(Codigo: string; permiteZeros: Boolean = false; permiteBrancos: Boolean = true): Boolean;
function VerificaCPF(Codigo: string): Boolean;
//     consiste um número de cartão de crédito
function VerFone(PEditDDD, PEditFone: TEdit; PFocus: Smallint): Boolean;
function VerCelular(const PNumero: string): Boolean ;
function Modulo10(const S: string): string;
function Modulo11(const S: string; const PesoMinimo: Smallint = 2): string;
function FormataCNPJ(Codigo: string): string;
function Modulo10Itau(const PNumero, PAgencia, PConta, PCarteira: string): string; overload;
function Modulo10Itau(const PNumero: string): string; overload;
function Modulo11Base7(const S: string): string;
function Modulo11BB (const PNumero: string): string;

//-------------------------------------------------------------------------------------------------------------------
procedure HabiliaDatasets(PDataSets: array of TDataSet; PEnabled: Boolean);
function FieldTypeParaStr(AFType: TFieldType): string;
//     Gera um CDS a partir da estrutura de um dataset qualquer e
//     não o ativa para que outros campos possam ser adicionados
procedure GeraCDSInativo(POrigem: TDataSet; CDS: TClientDataSet);
procedure GeraCDS(POrigem: TDataSet; CDS: TClientDataSet);
//     Copia um registro de um dataset para outro.
//     Obs.: a procedure somente move o registro mas não o grava
procedure ClonaUm(pOrigem, pDestino: TDataSet; const pAppend: Boolean; const pIgnorarCampos: String = '');
procedure ClonaTudo(POrigem, PDestino: TDataSet; const PAppend: Boolean);
procedure SetaFmtNum(DS: TDataSet; pCampo: string; PMask: string = '###,###,###,##0.00');
//  Salva o conteúdo do ClientDataSet num arquivo XML
//  Se pNome não contiver o caminho, somente o nome, o arquivo
//  será salvo no diretório: '<diretório_do_programa>\sis\sel'
//  Se o nome estiver em branco, o nome do arquivo será o nome do
//  form e o nome clientdataset concatenados
procedure GravaXML(FR: TForm; CDS: TClientDataSet; pNome: string = '');
function LeXML(FR: TForm; CDS: TClientDataSet; pNome: string = ''): Boolean;
// Difere da função LeXML pelo fato de não gerar exceção caso o XML esteja danificado
function CarregaXML(FR: TForm; CDS: TClientDataSet; pNome: string = ''): Boolean;
function DataSetParaXML(ADS: TDataSet; const ACampos: array of string): string;
function XMLParaDataset(ADS: TDataSet; const ACampos: array of string; const AXML: string; const ALimparDataSet: Boolean): Boolean;
//     carrega um clientdataset a partir do xml especificado e seta o primeiro campo como indice
function LeXMLSetaIndex(FR: TForm; CDS: TClientDataSet; pNome: string = ''): Boolean;
function RetValSql(const pValor: string; const pUpperCase: Boolean): string; overload;
function RetValSql(const pValor: string): string; overload;
function RetValSql(const pValor: Extended): string; overload;
function RetValSql(const pValor: TDateTime): string; overload;
function PreparaSql(const S: string): string;
//     gera uma instrução IN válida
function MontaSQL_IN(DS: TDataSet; const pCampo: string; const EntrePar: Boolean = true; const Espacado: Boolean = false): string; overload;
function MontaSQL_IN(ALista: TStrings; const ACampo: string; const AValoresEntreAspas: Boolean = false): string; overload;
function MontaSQL_OR(DS: TDataSet; const pCampo: string; const pAlias: string = ''): string;
function DataSetParaString(DS: TDataSet; const pCampo: string; const Espacado: Boolean = True; const Invertido: Boolean = False): string;
//     faz uma procura incremental no dataset passado como se fosse um locate simples
function Locate(DS: TDataSet; const PCampos: string;
                              const PValores: array of string;
                              const PInsensitive: Boolean;
                              const PDisableControls: Boolean = false;
                              const PBookmark: Boolean = True): Boolean;
//   verifica se o campo é numérico
function VerCampoNum(FL: TField): Boolean; overload;
function VerCampoNum(FT: TFieldType): Boolean; overload;
//-------------------------------------------------------------------------------------------------------------------
function GetInfoVersao(const FileName: string): string;
{ TTipoAmpulheta
    0: crHourGlass
    1: crAppStart
    2: crSqlWait }
type
  TTipoAmpulheta = 0..2;
procedure SetaCursorAmp; overload;
procedure SetaCursorAmp(const PTipo: TTipoAmpulheta); overload;
procedure SetaCursorDef;
procedure Navegar(const Endereco: string); overload;
procedure Navegar(FR: TForm; const Endereco: string); overload;
procedure Explorar(const Caminho: string);
procedure Executar(const CaminhoAplicativo: string);
procedure EnviarEmail(const Endereco: string);
procedure ChamaPainelControle_Sistema;
procedure ChamaPainelControle_Certificados;
procedure ChamaPainelControle_ConfigRegionais;
//     retorna o nome do usuário logado no sistema operacional
function RetUsuarioWindows: string;
function MontaCriptoString(const pValor: string; const pDesmontar: Boolean; const pTamanho: integer = -1): string;
function VerTeclaMovimento(const pKey: Word): Boolean;
procedure ControlaTeclaMesAno(var Key: Char; PMaskEdit: TMaskEdit);
procedure ControlaTeclaAnoMes(var Key: Char; PMaskEdit: TMaskEdit);
function ExportaDataSet(DS: TDataSet; const pNomeArq: string): string;
procedure ImportaCDS(CDS: TClientDataSet; const pNomeArq: string);
function IfThenColor(const PCondic: Boolean; const PTrue, PFalse: TColor): TColor;
// verifica se está rodando numa sessão remota (terminal server)
function VerSessaoRemota: Boolean;
function RetHostName(aIp:string):string;
//-------------------------------------------------------------------------------------------------------------------
function PreencherEsq(Str, PFilling: string; PTam: integer): string;
//     exclui uma substring dentro de uma string
function StrRemove(PStrSub, PStr: string): string;
//    retorna somente a parte string de PStr até que um caracter numérico apareça
function RetStrChar(const PStr: string): string;
function RetStrPonto(PSubStr, PStr: string): string;
function RetCharPonto(PSubStr, PStr: string): string;
function RetLinhaPonto(PSubStr, PStr: string): string;
function RetStrArray(PStr, pKey: string): string;
function RetNomeComputador: string;
function RetIPLocal : string;
function RetTaxaFin(ATaxaMes : Extended; ADias: Extended) : Extended;
function RetPerFin(ATaxaMes : Extended; ADias: Extended) : Extended;
function EqualizaFin(AValor, ATaxaMes : Extended; ADias: Extended; ASinal:string = '*') : Extended;
//function RetPesoFromDimensao(aDimensao : string; aTipo : Integer) : Extended;
function HorasToDec(st : string) : Double;
procedure DescarregaMemoriaApp;

function CodIBGEParaUF(const aCodigo: string; const aUFDefault: string = 'RS'): string;
function UFParaCodIBGE(const aUF: string; const aCodigoDefault: string = '43'): string;

function StringParaBase64(const AValor: string): string;
function Base64ParaString(const AValor: string): string;
procedure SplitStr(const Str: string; const Delimiter: Char; var ListOfStrings: TStrings) ;

type
  TRGBArray = array[Word] of TRGBTriple;
  pRGBArray = ^TRGBArray;

type
    TImgResizer = class
    public
          class procedure SmoothResizeBMP(Src, Dst: TBitmap);
          class procedure SmoothResizePNG(apng: TPngImage; NewWidth, NewHeight: integer);
          class function Redimensionar(APicOrigem, APicDestino: TPicture; const AProporcaoPercentual: Double;
                                       const AExtensao: string; const ACaminhoArquivo: string = ''): Int64;
    end;

function SubAspas(const T: string): string;

implementation

type
  THookWinControl = class(TWinControl);
  THookControl = class(TControl);
  TDateOrder = (doMDY, doDMY, doYMD);

const
  CenturyOffset: Byte = 60;

//-------------------------------------------------------------------------------------------------------------------
function SeparadorData: Char;
begin
     //Result := DateSeparator;
     Result := System.SysUtils.FormatSettings.DateSeparator;
end;

function SeparadorMilhar: Char;
begin
     //Result := ThousandSeparator;
     Result := System.SysUtils.FormatSettings.ThousandSeparator;
end;

function SeparadorDecimal: Char;
begin
     //Result := DecimalSeparator;
     Result := System.SysUtils.FormatSettings.DecimalSeparator;
end;

function FormatoDataPadrao: string;
begin
     //Result := ShortDateFormat;
     Result := System.SysUtils.FormatSettings.ShortDateFormat;
end;

procedure SetaFormatoDataPadrao(const AFormato: string);
begin
     //ShortDateFormat := AFormato;
     System.SysUtils.FormatSettings.ShortDateFormat := AFormato;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerificaCNPJ(Codigo: string; permiteZeros: Boolean = false; permiteBrancos: Boolean = true): Boolean;
var
     s: string;
     i, T, G: integer;
begin
     Result := true;

     if permiteBrancos then
     begin
        if (Codigo = '  .   .   /    -  ')
        or (Codigo = '') then
           exit;
     end;

     if not permiteZeros then
     begin
        if (Codigo = '00.000.000/0000-00')
        or (Codigo = '00000000000000') then
        begin
            Result := false;
            exit;
        end;
     end;


     Codigo := FH.StrInteiro(Codigo);
     Codigo := FH.FormataCNPJCPF(Codigo);
     try
        Codigo := Copy(Codigo, 1, 2) + Copy(Codigo, 4, 3) + Copy(Codigo, 8, 3) +
                  Copy(Codigo, 12, 4) + Copy(Codigo, 17, 2);
        s := Copy(Codigo, 1, 12);
        T := 0;

        for i := 1 to 4 do
            T := T + StrToInt(Copy(s, i, 1)) * (6 - i);
        for i := 1 to 8 do
            T := T + StrToInt(Copy(s, i + 4, 1)) * (10 - i);
        G := 11 - T mod 11;
        if G in [10, 11] then
           s := s + '0'
        else
           s := s + IntToStr(G);
        T := 0;
        for i := 1 to 5 do
            T := T + StrToInt(Copy(s, i, 1)) * (7 - i);
        for i := 1 to 8 do
            T := T + StrToInt(Copy(s, i + 5, 1)) * (10 - i);
        G := 11 - T mod 11;
        if G in [10, 11] then
           s := s + '0'
        else
           s := s + IntToStr(G);
        if Codigo <> s then
           Result := false
        else
           Result := true;
     except
           Result := false;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerificaCPF(Codigo: string): Boolean;
var
     s: string;
     i, T, G, j, N: integer;
begin
     try
        Result := true;
        Codigo := FH.LimpaString(Codigo, ['.']);
        if (FH.limpaEspacos(Codigo) = '-') or (Trim(Codigo) = '-') then
           exit;
        s := trim(FH.StrInteiro(Codigo));
        if (Length(s) < 11)
        or (s = '00000000000')
        or (s = '11111111111')
        or (s = '22222222222')
        or (s = '33333333333')
        or (s = '44444444444')
        or (s = '55555555555')
        or (s = '66666666666')
        or (s = '77777777777')
        or (s = '88888888888')
        or (s = '99999999999') then
        begin
             Result := false;
             exit;
        end;

        s := '';
        for j := 1 to Length(Codigo) do
        begin
             try
                N := StrToInt(Copy(Codigo, j, 1));
                s := s + IntToStr(N);
             except
                   Delete(Codigo, j, 1);
             end;
        end;
        Delete(s, 10, 2);
        T := 0;
        for i := 1 to 9 do
            T := T + StrToInt(Copy(s, i, 1)) * (11 - i);
        G := 11 - T mod 11;
        if G in [10, 11] then
           s := s + '0'
        else
           s := s + IntToStr(G);
        T := 0;
        for i := 1 to 10 do
            T := T + StrToInt(Copy(s, i, 1)) * (12 - i);
        G := 11 - T mod 11;
        if G in [10, 11] then
           s := s + '0'
        else
           s := s + IntToStr(G);
        if Codigo <> s then
           Result := false
        else
           Result := true;
     except
           Result := false
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetDataExtenso(PStrData: string; PDiaPorExtenso: Boolean): string;
var
     vDia, vMes, vAno: string;
begin
     try vDia := copy(PStrData, 1, 2); except end;
     try vMes := RetNomeMes(StrToInt(copy(PStrData, 4, 2))); except end;
     try vAno := copy(PStrData, 7, 4); except end;

     if PDiaPorExtenso = true then
       vDia := RetDiaSemanaExtenso(StrToDate(PStrData)) + ', ' + vDia;

     Result := vDia + ' de ' + vMes + ' de ' + vAno;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetDiaSemanaExtenso(PData: TDatetime; const MostrarFeira: Boolean = True): string;
begin
     Result := FH.SetaUpper( FormatDateTime('dddd', PData), 1 );
     if  (not MostrarFeira)
     and contem( Result, 'feira' ) then
         Result := limpaString( Result, ['-', 'feira'] );
end;

//-------------------------------------------------------------------------------------------------------------------
function BuscaTreeNode(PTreeView: TTreeView; S: string; PBuscaParcial: Boolean;
  PExpandir: Boolean = true): TTreeNode;
var
     N: TTreeNode;
     A, B: string;

     function Retorno: Boolean;
     begin
       if PBuscaParcial then
         Result := AnsiContainsText(B, A)
       else
         Result := AnsiSameText(A, B);
     end;

begin
     Result := nil;
     N := PTreeView.Items.GetFirstNode;
     while N <> nil do
     begin
          A := FH.LimpaChrEspecial(AnsiLowerCase(S));
          B := FH.LimpaChrEspecial(AnsiLowerCase(N.Text));
          if Retorno then
          begin
               if PExpandir then
               begin
                    N.MakeVisible;
                    PTreeView.Selected := N;
               end;
               Result := N;
               Break;
          end;
          N := N.GetNext;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function IsFloatMaiorQue(PStr: string; PMaiorQue: double): Boolean;
var
     E: Extended;
begin
     Result := TryStrToFloat(PStr, E);
     if Result then
       Result := E > PMaiorQue;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetNomeMes(const PMes: integer; const PDisplayFormat: string = 'mmmm'): string;
begin
     Result := FH.SetaUpper(FormatDateTime(PDisplayFormat, EncodeDate(2003, PMes, 1)), 1);
end;

//-------------------------------------------------------------------------------------------------------------------
function PreencherEsq(Str, PFilling: string; PTam: integer): string;
var
     J: integer;
begin
     for J := 1 to (PTam - Length(Str)) do
         Str := PFilling + Str;
     Str := copy(Str, 1, PTam);
     Result := Str;
end;

//-------------------------------------------------------------------------------------------------------------------
function SetaLocal(const PDir: string): string;
var
     tmpStr, tmpDir: string;
begin
     tmpDir := Trim(PDir);
     while IsDelimiter('/:', tmpDir, 1) do
           Delete(tmpDir, 1, 1);
     tmpStr := FH.AdicionaDelimitador(ExtractFilePath(Application.ExeName));
     Result := FH.AdicionaDelimitador(tmpStr + ExcludeTrailingPathDelimiter(tmpDir));
     if not SysUtils.DirectoryExists(Result) then
        if not SysUtils.ForceDirectories(Result) then
        begin
             Result := tmpStr;
             exit;
        end;
     Result := FH.AdicionaDelimitador(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function SetaLocalTmp: string;
begin
     Result := FH.SetaLocal('Tmp');
end;

//-------------------------------------------------------------------------------------------------------------------
function StrInteiro(pNumero: string): string;
const
     Num = ['0'..'9'];
var
     i: integer;
begin
     Result := '';
     for i := 1 to Length(pNumero) do
         if CharInSet(pNumero[i], Num) then
            Result := Result + pNumero[i];
end;

//-------------------------------------------------------------------------------------------------------------------
function StrRemove(PStrSub, PStr: string): string;
begin
     PStrSub := AnsiUpperCase(PStrSub);
     PStr := AnsiUpperCase(PStr);
     while Pos(PStrSub, PStr) > 0 do
           Delete(PStr, Pos(PStrSub, PStr), Length(PStrSub));
     Result := PStr;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetStrChar(const PStr: string): string;
var
     i: Smallint;
     s: string;
begin
     Result := '';
     if FH.StrInvalida(PStr) then
        exit;
     s := FH.LimpaChrEspecial(PStr);
     i := 1;
     while s[i] in ['A'..'Z', 'a'..'z', '_', #32] do
     begin
          Result := Result + s[i];
          Inc(i);
     end;
     Result := TrimRight(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetStrPonto(PSubStr, PStr: string): string;
var
     sa, sp, s1, s2: string;
     i: Smallint;
begin
     s1 := '';
     s2 := '';
     sa := copy(PStr, 1, Pos(PSubStr, PStr) - 1);
     sp := copy(PStr, Pos(PSubStr, PStr) + 1, Length(PStr));
     i := Length(sa);
     for i := Length(sa) downto 1 do
     begin
          if (Trim(sa[i]) = '') or (sa[i] = ',') then
             break
          else
             s1 := sa[i] + s1;
     end;
     i := 1;
     for i := 1 to Length(sp) do
     begin
          if (Trim(sp[i]) = '')
          or AnsiMatchText(sp[i], [',']) then
             break
          else
             s2 := s2 + sp[i];
     end;
     Result := s1 + PSubStr + s2;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetCharPonto(PSubStr, PStr: string): string;
var
     sa, sp, s1, s2: string;
     i: Smallint;
begin
     s1 := '';
     s2 := '';
     sa := copy(PStr, 1, Pos(PSubStr, PStr) - 1);
     sp := copy(PStr, Pos(PSubStr, PStr) + 1, Length(PStr));
     i := Length(sa);
     for i := Length(sa) downto 1 do
     begin
          if (sa[i] in ['a'..'z'])
          or (sa[i] in ['0'..'9'])
          or (sa[i] in ['A'..'Z']) then
             s1 := sa[i] + s1
          else
             break;
     end;
     i := 1;
     for i := 1 to Length(sp) do
     begin
          if (sp[i] in ['a'..'z'])
          or (sp[i] in ['0'..'9'])
          or (sp[i] in ['A'..'Z']) then
             s2 := s2 + sp[i]
          else
             break;
     end;
     Result := s1 + PSubStr + s2;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetLinhaPonto(PSubStr, PStr: string): string;
var
     sa, sp, s1, s2: string;
     i: Smallint;
begin
     s1 := '';
     s2 := '';
     sa := copy(PStr, 1, Pos(PSubStr, PStr) - 1);
     sp := copy(PStr, Pos(PSubStr, PStr) + 1, Length(PStr));
     i := Length(sa);
     for i := Length(sa) downto 1 do
     begin
          if (sa[i] <> #13) and (sa[i] <> #10) and (sa[i] <> #$D#$A) then
             s1 := sa[i] + s1
          else
             break;
     end;
     i := 1;
     for i := 1 to Length(sp) do
     begin
          if (sp[i] <> #13) and (sp[i] <> #10) and (sp[i] <> #$D#$A) then
             s2 := s2 + sp[i]
          else
             break;
     end;
     Result := s1 + PSubStr + s2;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetStrArray(PStr, pKey: string): string;
var
     s, c: string;
begin
     while PStr <> s do
     begin
          s := PStr;
          if Pos(';', s) > 0 then
             s := copy(s, 1, Pos(';', s) - 1);
          c := Trim(copy(s, 1, Pos('=', s) - 1));
          if c = pKey then
          begin
               Result := trim(s);
               exit;
          end;
          Delete(PStr, 1, Length(s) + 1);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function Modulo10(const S: string): string;
var
     i, P, M, T: integer;
begin
     M := 0;
     P := 2;
     for i := Length(S) downto 1 do
     begin
          T := StrToInt(Copy(S, i, 1)) * P;
          if T > 9 then
             M := M + 1 + (T - 10)
          else
             M := M + T;
          if P = 1 then
             P := 2
          else
             P := 1;
     end;
     M := 10 - M mod 10;
     if M = 10 then
        M := 0;
     Result := IntToStr(M);
end;

//-------------------------------------------------------------------------------------------------------------------
function Modulo11(const S: string; const PesoMinimo: Smallint = 2): string;
var
     i, P, T: integer;
begin
     Result := '';
     T := 0;
     P := PesoMinimo;
     for i := Length(S) downto 1 do
     begin
          T := T + StrToInt(Copy(S, i, 1)) * P;
          if P = 9 then
             P := PesoMinimo
          else
             Inc(P);
     end;
     T := 11 - (T mod 11);
     if T > 9 then
        T := 0;
     Result := IntToStr(T);
end;

//-------------------------------------------------------------------------------------------------------------------
function PreencheStr(const PDirecao: Shortint; const S: string; const PTam: SmallInt; const PChr: string = #32): string;
var
     tx: string;
begin
     tx := S;
     if Length(tx) > PTam then
        tx := Copy(tx, 1, PTam);
     Result := tx;
     case PDirecao of
          -1:
            begin
                 while Length(Result) < PTam do
                       Result := PChr + Result;
            end;
          1:
            begin
                 while Length(Result) < PTam do
                       Result := Result + PChr;
            end;
          0:
            begin
                 while Length(Result) < (((PTam div 2) - (Length(tx) div 2)) + Length(tx)) do
                       Result := PChr + Result;
                 while Length(Result) < PTam do
                       Result := Result + PChr;
            end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function PreencheStr(const S: string; const PTam: SmallInt; const PChr: string = #32): string;
begin
     Result := FH.PreencheStr(-1, S, PTam, PChr);
end;

//-------------------------------------------------------------------------------------------------------------------
function StrZero(const S: string; const PTam: SmallInt): string;
begin
     Result := FH.PreencheStr(-1, S, PTam, '0');
end;

//-------------------------------------------------------------------------------------------------------------------
function StrZero(const N: integer; const PTam: SmallInt): string;
begin
     Result := FH.PreencheStr(-1, FloatToStr(N), PTam, '0');
end;

//-------------------------------------------------------------------------------------------------------------------
function PreencheDir(const S: string; const PTam: SmallInt): string;
begin
     Result := FH.PreencheStr(1, S, PTam, FH.UM_ESPACO);
end;

//-------------------------------------------------------------------------------------------------------------------
function PreencheEsq(const S: string; const PTam: SmallInt): string;
begin
     Result := FH.PreencheStr(-1, S, PTam, FH.UM_ESPACO);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PadR(var PString: string; const PTam: integer; const PChr: string = ' ');
begin
     while Length(PString) < PTam do
           PString := PString + PChr;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PadL(var PString: string; const PTam: integer; const PChr: string = ' ');
begin
     while Length(PString) < PTam do
           PString := PChr + PString;
end;

//-------------------------------------------------------------------------------------------------------------------
function ContaStr(S, PSubStr: string): integer;
begin
     Result := ContaStr(S, PSubStr, -1, -1);
end;

//-------------------------------------------------------------------------------------------------------------------
function ContaStr(S, PSubStr: string; PIndex, PTotal: integer): integer; overload;
var
     j, i: integer;
begin
     j := 0;
     i := 0;
     if (PIndex < 0) and (PTotal < 0) then
     begin
          for j := 1 to Length(S) do
              if AnsiSameText(Copy(S, j, Length(PSubStr)), PSubStr) then
                 Inc(i);
     end
     else
     begin
          if PTotal > Length(S) then
             PTotal := Length(S);
          if PIndex <= PTotal then
          begin
               for j := PIndex to PTotal do
                   if AnsiSameText(Copy(S, j, Length(PSubStr)), PSubStr) then
                      Inc(i);
          end;
     end;
     Result := i;
end;

//-------------------------------------------------------------------------------------------------------------------
function Espacos(PTam: integer): string;
var
     i : Integer;
begin
     Result := '';
     for i := 1 to PTam do
         Result := Result + FH.UM_ESPACO;
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaChrEspecial(Str: string): string;
const
     cS1 = 'àâäãáêéëèíïìîôöõóòûúüùçñýÿÀÂÄÃÁÊÉËÈÍÏÌÎÔÖÕÓÒÛÚÜÙÇÑÝŸ';
     cS2 = 'aaaaaeeeeiiiiooooouuuucnyyAAAAAEEEEIIIIOOOOOUUUUCNYY';
var
     i: integer;
begin
     for i := 1 to Length(Str) do
         if Pos(Str[i], cS1) <> 0 then
            Str[i] := cS2[Pos(Str[i], cS1)];
     Result := Str;
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaAaZ(PStr: string): string;
var
     i: integer;
begin
     Result := '';
     for i := 1 to Length(PStr) do
         if (FH.IntOk(PStr[i])) or (PStr[i] = ',') then
            Result := Result + PStr[i];
end;

//-------------------------------------------------------------------------------------------------------------------
function FloatOk(const S: string): Boolean;
var
     E: Extended;
begin
     Result := TryStrToFloat(S, E);
end;

//-------------------------------------------------------------------------------------------------------------------
function IntOk(const S: string): Boolean;
const
      Num = ['0'..'9'];
var
      i: int64;
      x: Integer;
begin
     Result := TryStrToInt64(S, i);
     if Result then
     begin
          for x := 1 to Length(S) do
              if (not (S[x] in Num)) and (s[x] <> '-') then
              begin
                   Result := False;
                   Exit;
              end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function Int32Ok(const S: string): Boolean;
const
      Num = ['0'..'9'];
var
      i: integer;
      x: Integer;
begin
     Result := TryStrToInt(S, i);
     if Result then
     begin
          for x := 1 to Length(S) do
              if (not (S[x] in Num)) and (s[x] <> '-') then
              begin
                   Result := False;
                   Exit;
              end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function Int64Ok(const S: string): Boolean;
const
      Num = ['0'..'9'];
var
      i: int64;
      x: Integer;
begin
     Result := TryStrToInt64(S, i);
     if Result then
     begin
          for x := 1 to Length(S) do
              if (not (S[x] in Num)) and (s[x] <> '-') then
              begin
                   Result := False;
                   Exit;
              end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function IntInvalido(const S: string): Boolean;
const
      Num = ['0'..'9'];
var
      i: int64;
      x: Integer;
begin
     Result := not TryStrToInt64(S, i);
     if not Result then
     begin
          for x := 1 to Length(S) do
              if (not (S[x] in Num)) and (s[x] <> '-') then
              begin
                   Result := True;
                   Exit;
              end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ListaIntOk(const S: string): Boolean;
var
     t: string;
begin
     if Pos(',', S) = 0 then
        Result := FH.IntOk(S)
     else
     begin
          t := s + ',';
          while FH.Contem(t, ',') do
          begin
               Result := FH.IntOk(FH.copyPos(t, ','));
               if not Result then
                  Exit;
               t := FH.copyPosMax(t, ',');
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ListaStrOk(const S: string): Boolean;
var
     t: string;
begin
     if Pos(',', S) = 0 then
        Result := FH.StrOk(S)
     else
     begin
          t := s + ',';
          while FH.Contem(t, ',') do
          begin
               Result := FH.StrOk(FH.copyPos(t, ','));
               if not Result then
                  Exit;
               t := FH.copyPosMax(t, ',');
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function DataOk(const S: string): Boolean;
var
     D: TDateTime;
begin
     Result := TryStrToDate(S, D);
end;

//-------------------------------------------------------------------------------------------------------------------
function DatasOk(const D1, D2: string): Boolean;
var
     D: TDateTime;
begin
     Result := TryStrToDate(D1, D) and TryStrToDate(D2, D);
end;

//-------------------------------------------------------------------------------------------------------------------
function DataHoraOk(const S: string): Boolean;
var
     D: TDateTime;
begin
     Result := TryStrToDateTime(S, D);
end;

//-------------------------------------------------------------------------------------------------------------------
function DataInvalida(const S: string): Boolean;
var
     D: TDateTime;
begin
     Result := not TryStrToDate(S, D);
end;

//-------------------------------------------------------------------------------------------------------------------
function HoraOk(const S: string): Boolean;
var
     T: TDateTime;
begin
     Result := TryStrToTime(S, T);
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaZero(Texto: string): string;
var
     s: string;
     i, j: integer;
begin
     i := 0;
     j := Length(Texto);
     while j > i do
     begin
          s := Copy(Texto, 0, 1);
          if s = '0' then
          begin
               Delete(Texto, 1, 1);
               Inc(i);
          end
          else
          begin
               Result := Texto;
               exit;
          end;
     end;
     Result := Texto;
end;

//-------------------------------------------------------------------------------------------------------------------
function TrimX(const S: string; A: string): string;
var
     i, j: integer;
begin
     j := Length(S);
     i := 1;
     A := Copy(A, 1, 1);
     if A = '' then
        A := ' ';
     while (i <= j) and (S[i] <= A) do
           Inc(i);
     if i > j then
        Result := ''
     else
     begin
          while S[j] <= A do
                Dec(j);
          Result := Copy(S, i, j - i + 1);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function UltimoDia(PAno, PMes: SmallInt): SmallInt;
begin
     Result := MonthDays[IsLeapYear(PAno), PMes];
end;

//-------------------------------------------------------------------------------------------------------------------
function TerminaProcesso(PNomeExe: string): integer;
const
     PROCESS_TERMINATE = $0001;
var
     b: BOOL;
     H: THandle;
     T: TProcessEntry32;
begin
     Result   := 0;
     H        := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
     T.dwSize := Sizeof(T);
     b        := Process32First(H, T);
     while integer(b) <> 0 do
     begin
          if AnsiSameText(ExtractFileName(T.szExeFile), PNomeExe)
          or AnsiSameText(T.szExeFile, PNomeExe) then
             Result := integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), T.th32ProcessID), 0));
          b := Process32Next(H, T);
     end;
     CloseHandle(H);
end;

//-------------------------------------------------------------------------------------------------------------------
function ProcessoRodando(PNomeExe: string): Boolean;
var
     b: BOOL;
     H: THandle;
     T: TProcessEntry32;
begin
     Result   := false;
     H        := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
     T.dwSize := Sizeof(T);
     b        := Process32First(H, T);
     while integer(b) <> 0 do
     begin
          if AnsiSameText(ExtractFileName(T.szExeFile), PNomeExe) or
             AnsiSameText(T.szExeFile, PNomeExe) then
          begin
              Result := true;
              Break;
          end;
          b := Process32Next(H, T);
     end;
     CloseHandle(H);
end;

//-------------------------------------------------------------------------------------------------------------------
function ContaProcessosRodando(PNomeExe: string): integer;
var
     b: BOOL;
     H: THandle;
     T: TProcessEntry32;
begin
     Result   := 0;
     H        := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
     T.dwSize := Sizeof(T);
     b        := Process32First(H, T);
     while integer(b) <> 0 do
     begin
          if AnsiSameText(ExtractFileName(T.szExeFile), PNomeExe) or
             AnsiSameText(T.szExeFile, PNomeExe) then
             Inc(Result);
          b := Process32Next(H, T);
     end;
     CloseHandle(H);
end;

//-------------------------------------------------------------------------------------------------------------------
function GetInfoVersao(const FileName: string): string;
const
     KeyBr: array[1..9] of string =
      ('Empresa', 'Descricao', 'Versao do Arquivo', 'Nome Interno', 'Copyright',
       'Nome Original do Arquivo', 'Nome do Produto', 'Versao do Produto',
       'Comentarios');
var
     x      : cardinal;
     BT, T  : integer;
     BF     : PChar;
     L, H   : Word;
     ns, rt : Pointer;
     s      : string;
begin
     Result := '';
     BT := GetFileVersionInfoSize(PChar(FileName), x);
     if BT = 0 then
        Exit;
     GetMem(BF, Succ(BT));
     try
        if GetFileVersionInfo(PChar(FileName), 0, BT, BF) then
           if VerQueryValue(BF, '\VarFileInfo\Translation', ns, UINT(T)) then
           begin
                L := LoWord(Longint(ns^));
                H := HiWord(Longint(ns^));
                s := Format('\StringFileInfo\0%x0%x\%s', [L, H, 'FileVersion']);
                if VerQueryValue(BF, PChar(s), rt, UINT(T)) then
                   Result := PChar(rt);
           end;
     finally
            FreeMem(BF, Succ(BT));
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function MsgBox(const pTexto, PCaption: string; AFlags: Longint = 0): integer;
var
    S: string;
begin
    S := PCaption;
    if S = '' then
       S := Application.Title;
    Result := Application.MessageBox(PChar(pTexto), PChar(S), AFlags);
    Screen.ActiveForm.Repaint;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure MsgA(const S: string);
begin
     FH.BlockInput(false);
     MessageDlg(S, mtWarning, [mbOK], -1);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure MsgA(const S: string; const Args: array of const);
begin
     FH.BlockInput(false);
     MessageDlg(Format(S, Args), mtWarning, [mbOK], -1);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure MsgE(const S: string);
begin
     FH.BlockInput(false);
     MessageDlg(S, mtError, [mbOK], -1);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure MsgE(const S: string; const Args: array of const);
begin
     FH.BlockInput(false);
     MessageDlg(Format(S, Args), mtError, [mbOK], -1);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure MsgI(const S: string);
begin
     FH.BlockInput(false);
     MessageDlg(S, mtInformation, [mbOK], -1);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure MsgI(const S: string; const Args: array of const);
begin
     FH.BlockInput(false);
     MessageDlg(Format(S, Args), mtInformation, [mbOK], -1);
end;

//-------------------------------------------------------------------------------------------------------------------
function MsgSN(const S: string; PFlag: TFlagMsgSN = 0): integer;
var
     T: TMsgDlgType;
begin
     FH.BlockInput(false);

     case PFlag of
          0: T := mtConfirmation;
          1: T := mtError;
          2: T := mtWarning;
          3: T := mtInformation;
     else
         T := mtConfirmation;
     end;

     Result := MessageDlg(S, T, [mbYes, mbNo], -1);

     if Result <> mrYes then
        Result := 0
     else
        Result := 1;
end;

//-------------------------------------------------------------------------------------------------------------------
function MsgSN(const S: string; const Args: array of const; PFlag: TFlagMsgSN = 0): integer;
begin
     Result := FH.MsgSN(Format(S, Args), PFlag);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaStatusCheckListBox(PStatus: Boolean; CB: TCheckListBox);
var
     I: integer;
begin
     for I := 0 to CB.Items.Count - 1 do
         CB.Checked[I] := PStatus;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaStatusListView(PStatus: Boolean; LV: TListView);
var
     I: integer;
begin
     if not LV.Checkboxes then
        exit;
     for I := 0 to LV.Items.Count - 1 do
         LV.Items[I].Checked := PStatus;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaArray(PArray: array of string; pValor: string = '');
var
     I: integer;
begin
     for I := Low(PArray) to High(PArray) do
         PArray[I] := pValor;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaArray(PArray: array of integer; pValor: integer = 0);
var
     I: integer;
begin
     for I := Low(PArray) to High(PArray) do
         PArray[I] := pValor;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaArray(PArray: array of double; pValor: double = 0);
var
     I: integer;
begin
     for I := Low(PArray) to High(PArray) do
         PArray[I] := pValor;
end;

//-------------------------------------------------------------------------------------------------------------------
function ArrayPos(PArray: array of Boolean; pValor: Boolean): integer;
var
     I: integer;
begin
     Result := Low(PArray) - 1;
     for I := Low(PArray) to High(PArray) do
     begin
          if PArray[I] = pValor then
          begin
               Result := I;
               Break;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ArrayPos(PArray: array of double; pValor: double): integer;
var
     I: integer;
begin
     Result := Low(PArray) - 1;
     for I := Low(PArray) to High(PArray) do
     begin
          if PArray[I] = pValor then
          begin
               Result := I;
               Break;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ArrayPos(PArray: array of integer; pValor: integer): integer;
var
     I: integer;
begin
     Result := Low(PArray) - 1;
     for I := Low(PArray) to High(PArray) do
     begin
          if PArray[I] = pValor then
          begin
               Result := I;
               Break;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ArrayPos(PArray: array of string; pValor: string): integer;
var
     I: integer;
begin
     Result := Low(PArray) - 1;
     for I := Low(PArray) to High(PArray) do
     begin
          if PArray[I] = pValor then
          begin
               Result := I;
               Break;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function DataSqlMDA(PStrData: string): string;
begin
     Result := QuotedStr(SqlTimeStampToStr('mm/dd/yyyy', DateTimeToSqlTimeStamp(StrToDate(PStrData))));
end;

//-------------------------------------------------------------------------------------------------------------------
function DataSqlDefault(PStrData: string): string;
begin
     Result := '"'+SqlTimeStampToStr('mm/dd/yyyy', DateTimeToSqlTimeStamp(StrToDate(PStrData)))+'"';
end;

//-------------------------------------------------------------------------------------------------------------------
function DataSqlDefault(PData: TDateTime): string;
begin
     Result := FH.DataSqlDefault(DateToStr(PData));
end;

//-------------------------------------------------------------------------------------------------------------------
function FormataCNPJ(Codigo: string): string;
begin
     if Pos('.', Codigo) = 0 then
     begin
          if Length(Codigo) < 14 then
             Codigo := FH.StrZero(Codigo, 14);
          Insert('.', Codigo, 3);
          Insert('.', Codigo, 7);
          Insert('/', Codigo, 11);
          Insert('-', Codigo, 16);
     end;
     Result := Codigo;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistry(const pKey, pNome, PConteudo: string; const PSubKeys: string = '');
var
  Reg: TRegistry;
  Local: string;
begin
  Local := Format('\%s\%s\%s%s', [vrgRoot, vrgSubRoot, pKey, PSubKeys]);
  try
    Reg := TRegistry.Create;
    try
      with Reg do
      begin
        RootKey := vrgHKeyDefault1;
        OpenKey(Local, true);
        WriteString(pNome, PConteudo);
      end;
    except
      with Reg do
      begin
        RootKey := vrgHKeyDefault2;
        OpenKey(Local, true);
        WriteString(pNome, PConteudo);
      end;
    end;
  finally
    Reg.Free;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistry(const pKey, pNome: string; const PSubKeys: string = ''): string;
var
  Reg: TRegistry;
  Local: string;
begin
  Result := '';
  Local := Format('\%s\%s\%s%s', [vrgRoot, vrgSubRoot, pKey, PSubKeys]);
  try
    Reg := TRegistry.Create;
    with Reg do
    begin
      RootKey := vrgHKeyDefault1;
      if OpenKey(Local, false) then
        Result := ReadString(pNome)
      else
      begin
        RootKey := vrgHKeyDefault2;
        if OpenKey(Local, false) then
          Result := ReadString(pNome);
      end;
    end;
  finally
    Reg.Free;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryInt(pKey: TForm; pNome: string; PConteudo: integer);
begin
  FH.GravaRegistry(pKey.Name, pNome, IntToStr(PConteudo));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryStr(pKey: TForm; pNome, PConteudo: string);
begin
  FH.GravaRegistry(pKey.Name, pNome, PConteudo);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryBool(pKey: TForm; pNome: string; PConteudo: Boolean);
begin
  FH.GravaRegistry(pKey.Name, pNome, BoolToStr(PConteudo));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryInt(pKey, pNome: string; PConteudo: integer);
begin
  FH.GravaRegistry(pKey, pNome, IntToStr(PConteudo));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryStr(pKey, pNome, PConteudo: string);
begin
  FH.GravaRegistry(pKey, pNome, PConteudo);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryBool(pKey, pNome: string; PConteudo: Boolean);
begin
  FH.GravaRegistry(pKey, pNome, BoolToStr(PConteudo));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryReal(pKey: TForm; pNome: string; PConteudo: Extended);
begin
  FH.GravaRegistry(pKey.Name, pNome, FloatToStr(PConteudo));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryReal(pKey, pNome: string; PConteudo: Extended);
begin
  FH.GravaRegistry(pKey, pNome, FloatToStr(PConteudo));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryDate(pKey: TForm; pNome: string; PConteudo: TDateTime);
begin
  FH.GravaRegistry(pKey.Name, pNome, DateToStr(PConteudo));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryDate(pKey, pNome: string; PConteudo: TDateTime);
begin
  FH.GravaRegistry(pKey, pNome, DateToStr(PConteudo));
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryStr(pKey: TForm; pNome: string; PDef: string = ''): string;
begin
  Result := FH.LeRegistry(pKey.Name, pNome);
  if Result = '' then
    Result := PDef;
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryInt(pKey: TForm; pNome: string; PDef: integer = 0): integer;
begin
  Result := StrToIntDef(FH.LeRegistry(pKey.Name, pNome), PDef);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryBool(pKey: TForm; pNome: string; PDef: Boolean = false):
  Boolean;
begin
  Result := StrToBoolDef(FH.LeRegistry(pKey.Name, pNome), PDef);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryStr(pKey, pNome: string; PDef: string = ''): string;
begin
  Result := FH.LeRegistry(pKey, pNome);
  if Result = '' then
    Result := PDef;
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryInt(pKey, pNome: string; PDef: integer = 0): integer;
begin
  Result := StrToIntDef(FH.LeRegistry(pKey, pNome), PDef);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryBool(pKey, pNome: string; PDef: Boolean = false): Boolean;
begin
  Result := StrToBoolDef(FH.LeRegistry(pKey, pNome), PDef);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryReal(pKey: TForm; pNome: string; PDef: Extended = 0): Extended;
begin
  Result := StrToFloatDef(FH.LeRegistry(pKey.Name, pNome), PDef);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryReal(pKey, pNome: string; PDef: Extended = 0): Extended;
begin
  Result := StrToFloatDef(FH.LeRegistry(pKey, pNome), PDef);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryDate(pKey: TForm; pNome: string; PDef: TDateTime = 0): TDateTime;
begin
  if PDef = 0 then
    PDef := Date;
  Result := StrToDateDef(FH.LeRegistry(pKey.Name, pNome), PDef);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryDate(pKey, pNome: string; PDef: TDateTime = 0): TDateTime;
begin
  if PDef = 0 then
    PDef := Date;
  Result := StrToDateDef(FH.LeRegistry(pKey, pNome), PDef);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeRegistryGeral(pKey, pNome: string): string;
var
  Reg: TRegistry;
  Local: string;
begin
  Result := '';
  Local := Format('\%s\%s', [vrgRoot, pKey]);
  Reg := TRegistry.Create;
  with TRegistry.Create do
  begin
    try
      RootKey := vrgHKeyDefault1;
      if OpenKey(Local, false) then
        Result := ReadString(pNome)
      else
      begin
        RootKey := vrgHKeyDefault2;
        if OpenKey(Local, false) then
          Result := ReadString(pNome);
      end;
    finally
      Free;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaRegistryGeral(pKey, pNome, PConteudo: string);
var
  Reg: TRegistry;
  Local: string;
begin
  Local := Format('\%s\%s', [vrgRoot, pKey]);
  Reg := TRegistry.Create;
  try
    with TRegistry.Create do
    begin
      RootKey := vrgHKeyDefault1;
      OpenKey(Local, true);
      WriteString(pNome, PConteudo);
      Free;
    end;
  except
    with TRegistry.Create do
    begin
      RootKey := vrgHKeyDefault2;
      OpenKey(Local, true);
      WriteString(pNome, PConteudo);
      Free;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaRegistry(pKey: string; PLimpaTudo: Boolean; pVal: string = '';
  const PSubKeys: string = ''): Boolean;
var
  Reg: TRegistry;
  Local: string;
  L: TStrings;
  I: integer;
begin
  Local := Format('\%s\%s\%s%s', [vrgRoot, vrgSubRoot, pKey, PSubKeys]);
  Reg := TRegistry.Create;
  with TRegistry.Create do
  begin
    try
      RootKey := vrgHKeyDefault1;
      if not OpenKey(Local, false) then
      begin
        RootKey := vrgHKeyDefault2;
        if not OpenKey(Local, false) then
          exit;
      end;

      if not PLimpaTudo then
        Result := DeleteValue(pVal)
      else
      begin
        try
          L := TStringList.Create;
          Result := true;
          GetValueNames(L);
          try
            for I := 0 to L.Count - 1 do
              if L[I] <> '' then
                DeleteValue(L[I]);
          except
            Result := false;
          end;
        finally
          L.Free
        end;
      end;
    finally
      Free;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure CarregaRegistry(pKey: string; Lista: TStrings; const PSubKeys: string = ''; const CarregaKeys: Boolean = False);
var
  Reg: TRegistry;
  Local: string;
begin
  Local := Format('\%s\%s\%s%s', [vrgRoot, vrgSubRoot, pKey, PSubKeys]);
  Reg := TRegistry.Create;
  with TRegistry.Create do
  begin
    try
      RootKey := vrgHKeyDefault1;
      if not OpenKey(Local, false) then
      begin
        RootKey := vrgHKeyDefault2;
        if not OpenKey(Local, false) then
          exit;
      end;
      if CarregaKeys then
        GetKeyNames(Lista)
      else
        GetValueNames(Lista);
    finally
      Free;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function TrataData(const S: string; PDef: string = ''): string;
begin
     Result := S;
     if not FH.DataOk(Result) then
        Result := PDef;
end;

//-------------------------------------------------------------------------------------------------------------------
function TrataDataHora(const S: string; PDef: string = ''): string;
begin
     Result := S;
     if not FH.DataHoraOk(Result) then
        Result := PDef;
end;

//-------------------------------------------------------------------------------------------------------------------
function TrataInt(const S: string; PDef: string = '0'): string;
begin
     Result := S;
     if not FH.IntOk(Result) then
        Result := PDef;
end;

//-------------------------------------------------------------------------------------------------------------------
function TrataHora(const S: string; PDef: string = ''): string;
begin
     Result := S;
     if not FH.HoraOk(Result) then
        Result := PDef;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetDataArquivo(const pNome: string): TDateTime;
begin
     if not FileExists(pNome) then
        raise Exception.CreateFmt('Arquivo ''%s'' não existe', [pNome]);
     Result := FileDateToDateTime(FileAge(pNome));
end;

//-------------------------------------------------------------------------------------------------------------------
function AdicionaDelimitador(const S: string): string;
begin
     Result := IncludeTrailingPathDelimiter(S);
end;

//-------------------------------------------------------------------------------------------------------------------
function ZeroOk(const F: Extended): Boolean;
begin
     Result := FloatToStrF(F, ffFixed, 14, 2) = '0,00';
end;

//-------------------------------------------------------------------------------------------------------------------
function ZeroOuMenor(const F: Extended): Boolean;
begin
    Result := (F <= 0) or ZeroOk(F);
end;

//-------------------------------------------------------------------------------------------------------------------
function NaoZero(const F: Extended): Boolean;
begin
     Result := FloatToStrF(F, ffFixed, 14, 2) <> '0,00';
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaCursorAmp;
begin
     Screen.Cursor := crHourGlass;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaCursorAmp(const PTipo: TTipoAmpulheta);
const
     C: array[TTipoAmpulheta] of TCursor = (crHourGlass, crAppStart, crSQLWait);
begin
     Screen.Cursor := C[PTipo];
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaCursorDef;
begin
     Screen.Cursor := crDefault;
end;

//-------------------------------------------------------------------------------------------------------------------
function HojeStr: string;
begin
     Result := DateToStr(Date);
end;

//-------------------------------------------------------------------------------------------------------------------
function HoraExata: string;
begin
     Result := TimeToStr(SysUtils.Time);
end;

//-------------------------------------------------------------------------------------------------------------------
function HoraStr(const PHora: TTime = 1): string;
var
     H: TTime;
begin
     if PHora = 1 then
        H := SysUtils.Time
     else
        H := PHora;
     Result := copy(TimeToStr(H), 1, 5); // 09:00
end;

//-------------------------------------------------------------------------------------------------------------------
function HoraStr(const PHora: string): string;
begin
     Result := FH.HoraStr(StrToTime(PHora));
end;

//-------------------------------------------------------------------------------------------------------------------
function NowStr: string;
begin
     Result := copy(TimeToStr(SysUtils.Time), 1, 5);
end;

//-------------------------------------------------------------------------------------------------------------------
function TimeStamp: string;
begin
     Result := DateTimeToStr(Now);
end;

//-------------------------------------------------------------------------------------------------------------------
function TimeStampString: string;
begin
     Result := FormatDateTime('ddmmyyyy.hhmmsszzzz', Now);
end;

//-------------------------------------------------------------------------------------------------------------------
function MsgFocalize(pCampo: TWinControl; const PMsg: string = ''; const MostrarNomeDoCampo: Boolean = false): Boolean;
var
     vMsg: string;
begin
     vMsg := IfThen(PMsg = '', FH.vrgDefErrMsg, PMsg);
     if vMsg = FH.MSG_DEFAULT_VALIDACAO then
        if MostrarNomeDoCampo then
           if RightStr(vMsg, 1) = '.' then
              vMsg := FH.CopyMin(vMsg, 1); // remove o ponto final
     if MostrarNomeDoCampo then
     begin
          if pCampo.Hint <> '' then
             vMsg := vMsg + FH.UM_ESPACO + QuotedStr(pCampo.Hint);
     end;
     FH.Focalize(pCampo);
     FH.MsgA(vMsg);
     FH.SetaCursorDef;
     Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
function MsgFocalizeSe(const PCondicao: Boolean; pCampo: TWinControl; const PMsg: string = ''; const MostrarNomeDoCampo: Boolean = false): Boolean;
begin
     Result := PCondicao;
     if Result then
        FH.MsgFocalize(pCampo, PMsg, MostrarNomeDoCampo);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ForceEvent(PComp: TControl; PEvento: TNotifyEvent; PSender: TControl = nil);
begin
     if PSender = nil then
        PSender := PComp;
     with THookControl(PComp) do
          PEvento(PSender);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ForceClick(PComp: TControl; PSender: TControl = nil);
begin
     FH.ForceEvent(PComp, THookControl(PComp).OnClick, PSender);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ForceExit(PComp: TWinControl; PSender: TWinControl = nil);
begin
     FH.ForceEvent(PComp, THookWinControl(PComp).OnExit, PSender);
end;

//-------------------------------------------------------------------------------------------------------------------
function Focalize(WC: TWinControl): Boolean;
var
     p: TCustomForm;
begin
     if WC = nil then
       exit;
     with WC do
     begin
          Result := CanFocus;
          if Result then
          begin
               p := GetParentForm(WC);
               if p <> nil then
               begin
                    try p.FocusControl(WC); except end
               end
               else
               if ParentWindow <> 0 then
                  Windows.SetFocus(Handle);
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function Focalize(AHandle: HWnd): Boolean;
begin
     Result := Windows.SetFocus(AHandle) <> 0;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure FocalizeProximo(WC: TWinControl);
begin
     if WC.Owner <> nil then
        if WC.Owner is TWinControl then
           THookWinControl(WC.Owner).SelectNext(WC, True, True);
end;

//-------------------------------------------------------------------------------------------------------------------
function FocalizeSe(const PCondicao: Boolean; PWnCtrTrue, PWnCtrFalse: TWinControl): Boolean;
begin
     Result := PCondicao;
     if Result then
        FH.Focalize(PWnCtrTrue)
     else
        FH.Focalize(PWnCtrFalse);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetForm(const FR: string): TForm;
var
     I: integer;
begin
     Result := nil;
     for I := 0 to Screen.FormCount - 1 do
         if AnsiSameText((Screen.Forms[I] as TForm).Name, FR) then
         begin
              Result := (Screen.Forms[I] as TForm);
              Break;
         end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormComp(const FR, PCtr: string): TComponent;
begin
     Result := nil;
     try
        Result := FH.RetForm(FR).FindComponent(PCtr);
     except
        Result := nil;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormCds(const FR, PCtr: string): TClientDataSet;
begin
    Result := FH.RetFormComp(FR, PCtr) as TClientDataSet;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormControl(const FR, PCtr: string): TControl;
begin
     Result := TControl(FH.RetFormComp(FR, PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormControl(FR: TForm; const PCtr: string; const PIndex: integer): TControl;
begin
  Result := TControl(FH.RetFormComp(FR.Name, PCtr + IntToStr(PIndex)));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormWinControl(const FR, PCtr: string): TWinControl;
begin
  Result := TWinControl(FH.RetFormComp(FR, PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormEdit(const FR, PCtr: string): TEdit;
begin
  Result := TEdit(FH.RetFormComp(FR, PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormEdit(FR: TForm; const PCtr: string): TEdit;
begin
  Result := TEdit(FH.RetFormComp(FR.Name, PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormEdit(FR: TForm; const PCtr: string; const PIndex: integer): TEdit;
begin
  Result := TEdit(FH.RetFormComp(FR.Name, PCtr + IntToStr(PIndex)));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormButton(const FR, PCtr: string): TButton;
begin
  Result := TButton(FH.RetFormComp(FR, PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormLabel(const FR, PCtr: string): TLabel;
begin
  Result := TLabel(FH.RetFormComp(FR, PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormComboBox(const FR, PCtr: string): TComboBox;
begin
  Result := TComboBox(FH.RetFormComp(FR, PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetFormMaskEdit(const FR, PCtr: string): TMaskEdit;
begin
  Result := TMaskEdit(FH.RetFormComp(FR, PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetAtvFormComp(const PCtr: string): TComponent;
begin
  Result := nil;
  if Screen.ActiveForm = nil then
    exit;
  Result := TComponent(Screen.ActiveForm.FindComponent(PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetAtvFormEdit(const PCtr: string): TEdit;
begin
  Result := TEdit(FH.RetAtvFormComp(PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetAtvFormControl(const PCtr: string): TControl;
begin
  Result := TControl(FH.RetAtvFormComp(PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetAtvFormWinControl(const PCtr: string): TWinControl;
begin
  Result := TWinControl(FH.RetAtvFormControl(PCtr));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetCodigoStr(const S: string; const PSep: string = ' '): string;
begin
  Result := Trim(LeftStr(S, Pos(PSep, S) - Length(PSep)));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetDescriStr(const S: string; const PSep: string = ' '): string;
begin
  Result := Trim(Copy(S, Pos(PSep, S) + Length(PSep), MaxInt));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure FocalizeFirst(PContainer: TObject);
begin
     THookWinControl(PContainer).SelectFirst;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure StrParaLista(const POrigem: string; var PDestino: TStrings);
var
     s: string;
begin
     s := Trim(POrigem);
     if PDestino <> nil then
        PDestino.Clear;
     if s = '' then
        exit;
     ExtractStrings([',',';'], [' '], PChar(s), PDestino);
end;

//-------------------------------------------------------------------------------------------------------------------
function ChamaExec(const F: string; FR: TForm): string;
var
     r : HINST;
begin
     Result := '';
     r := ShellExecute(FR.Handle, nil, PChar(F), nil, nil, SW_SHOWNORMAL);
     case r of
          ERROR_FILE_NOT_FOUND   : Result := 'Arquivo especificado não encontrado.' + ' [Código: ' + IntToStr(r) + ']';
          ERROR_PATH_NOT_FOUND   : Result := 'Caminho especificado não encontrado.' + ' [Código: ' + IntToStr(r) + ']';
          SE_ERR_ASSOCINCOMPLETE : Result := 'A associação do nome de arquivo está incompleta ou é inválida.' + ' [Código: ' + IntToStr(r) + ']';
          SE_ERR_NOASSOC         : Result := 'Não há aplicação associada com a extensão do arquivo especificado.' + ' [Código: ' + IntToStr(r) + ']';
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ExecutaArquivo(const F: string; FR: TForm = nil);
var
     resp, cod: string;
begin
     FH.SetaCursorAmp;
     try
        if FR = nil then
           FR := Application.MainForm;
        resp := ChamaExec(F, FR);
        if resp <> '' then
        begin
             FH.PrMsg_AT(resp);
             cod := FH.copyPos(FH.CopyPosMax(resp, 'Código:'), ']');
             if FH.Contem(resp, 'Código:') and FH.IntOk(cod) then
             begin
                  if  (StrToIntDef(cod, -1) = SE_ERR_NOASSOC)
                  and (FH.strok(ExtractFilePath(F)))
                  and (DirectoryExists(ExtractFilePath(F))) then
                      FH.Explorar(ExtractFilePath(F));
             end;
        end;
     finally
            FH.SetaCursorDef;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function TemAaZ(const PStr: string): Boolean;
const
     Alpha = ['A'..'Z', 'a'..'z'];
var
     I: integer;
begin
     Result := Length(PStr) > 0;
     if not Result then
        exit;
     for I := 1 to Length(PStr) do
         if PStr[I] in Alpha then
            exit;
     Result := false;
end;

//-------------------------------------------------------------------------------------------------------------------
function CopyInvertido(S: string; Index, Count: integer): string;
begin
     Result := ReverseString(Copy(ReverseString(S), Index, Count));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure DsnCanvas(PCanvas: TCanvas; PRect: TRect; DX, DY: integer; const PStr: string; PAlinhamento: TAlignment);
const
  AlinFlag: array[TAlignment] of integer =
  (DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
   DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
   DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX);

  RTL: array[Boolean] of integer = (0, DT_RTLREADING);
  cReverseWriting: Boolean = false;
var
  B, R: TRect;
  vHld, Esquerda: integer;
  vRef: TColorRef;
  vBmp: TBitmap;
begin
  vRef := ColorToRGB(PCanvas.Brush.Color);
  if GetNearestColor(PCanvas.Handle, vRef) = vRef then
  begin
    if (PCanvas.CanvasOrientation = coRightToLeft) and (not cReverseWriting) then
      ChangeBiDiModeAlignment(PAlinhamento);
    case PAlinhamento of
      taLeftJustify: Esquerda := PRect.Left + DX;
      taRightJustify: Esquerda := PRect.Right - PCanvas.TextWidth(PStr) - 3;
    else { taCenter }
      Esquerda := PRect.Left + (PRect.Right - PRect.Left) shr 1 - (PCanvas.TextWidth(PStr) shr 1);
    end;
    PCanvas.TextRect(PRect, Esquerda, PRect.Top + DY, PStr);
  end
  else
  begin
    vBmp := TBitmap.Create;
    vBmp.Canvas.Lock;
    try
      with vBmp, PRect do
      begin
        Width := Max(Width, Right - Left);
        Height := Max(Height, Bottom - Top);

        R := Rect(DX, DY, Right - Left - 1, Bottom - Top - 1);
        B := Rect(0, 0, Right - Left, Bottom - Top);
      end;
      with vBmp.Canvas do
      begin
        Font := PCanvas.Font;
        Font.Color := PCanvas.Font.Color;
        Brush := PCanvas.Brush;
        Brush.Style := bsSolid;
        FillRect(B);
        SetBkMode(Handle, TRANSPARENT);

        if (PCanvas.CanvasOrientation = coRightToLeft) then
          ChangeBiDiModeAlignment(PAlinhamento);

        DrawText(Handle, PChar(PStr), Length(PStr), R, AlinFlag[PAlinhamento] or RTL[cReverseWriting]);
      end;
      if PCanvas.CanvasOrientation = coRightToLeft then
      begin
        vHld := PRect.Left;
        PRect.Left := PRect.Right;
        PRect.Right := vHld;
      end;
      PCanvas.CopyRect(PRect, vBmp.Canvas, B);
    finally
      vBmp.Canvas.Unlock;
      vBmp.Free;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure StringGridDsnStr(SG: TStringGrid; const R: TRect; PAlinhamento: integer; const PStr: string);
var
  A: TAlignment;
begin
  case PAlinhamento of
    0: A := taCenter;
    1: A := taRightJustify;
    -1: A := taLeftJustify;
  end;
  FH.DsnCanvas(SG.Canvas, R, 2, 2, PStr, A);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GridDsnCel(GR: TDBGrid; const R: TRect; DataCol: integer; PColuna: TColumn;
  PState: TGridDrawState; PCorFonte, PCorBrush: TColor; PEstiloFonte: TFontStyles;
  PVerificaFoco: Boolean = true; PCorSelecionada: TColor = clHighlightText);
begin
  with GR.Canvas do
  begin
    Font.Style := PEstiloFonte;
    Font.Color := PCorFonte;
    Brush.Color := PCorBrush;
    if gdSelected in PState then
    begin
      Font.Color := PCorSelecionada;
      if PVerificaFoco then
        Brush.Color := clHighlight;
    end;
    if (PVerificaFoco) and (not GR.Focused) and (not (gdSelected in PState)) then
      Font.Color := PCorFonte;
    FillRect(R);
  end;
  GR.DefaultDrawColumnCell(R, DataCol, PColuna, PState);
end;

//-------------------------------------------------------------------------------------------------------------------
function FonteParaStr(const F: TFont; const FlatString: Boolean = False): string;

  function Style: string;
  begin
       Result := '';
       if fsBold in F.Style then
          Result := Result + 'fsBold,';
       if fsItalic in F.Style then
          Result := Result + 'fsItalic,';
       if fsUnderline in F.Style then
          Result := Result + 'fsUnderline,';
       if fsStrikeout in F.Style then
          Result := Result + 'fsStrikeout,';
       if Result = '' then
          exit;
       Delete(Result, Length(Result), 1);
  end;

  function Pitch: string;
  begin
       Result := 'fpDefault';
       if F.Pitch = fpVariable then
          Result := 'fpVariable'
       else
       if F.Pitch = fpFixed then
          Result := 'fpFixed';
  end;

var
     L: TStrings;
begin
     L := TStringList.Create;
     try
        L.Add(Format('Charset:%d', [F.Charset]));
        L.Add(Format('Color:%s', [ColorToString(F.Color)]));
        L.Add(Format('Height:%d', [F.Height]));
        L.Add(Format('Name:%s', [F.Name]));
        L.Add(Format('Pitch:%s', [Pitch]));
        L.Add(Format('Size:%d', [F.Size]));
        L.Add(Format('Style:%s', [Style]));
        if FlatString then
           Result := FH.SubstituiQuebras(L.Text, True)
        else
           Result := L.Text;
     finally
        L.Free;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function StrParaFonte(const S: string; PDefault: TFont; const FlatString: Boolean = False): TFont;
var
     L: TStrings;
     I: integer;

     function GetVal(S: string): string;
     begin
          Result := RightStr(S, AnsiPos(ReverseString(':'), ReverseString(S)) - 1);
     end;

     function GetID(S: string): string;
     begin
          Result := LeftStr(S, Pos(':', S) - 1);
     end;

     function GetPitch: TFontPitch;
     var
          S: string;
     begin
          S := GetVal(L[I]);
          if S = 'fpVariable' then
             Result := fpVariable
          else
          if S = 'fpFixed' then
             Result := fpFixed
          else
             Result := fpDefault;
     end;

     function GetStyle: TFontStyles;
     var
          S: string;
     begin
          S := GetVal(L[I]);
          Result := [];
          if Pos('fsBold', S) > 0 then
             Result := Result + [fsBold];
          if Pos('fsItalic', S) > 0 then
             Result := Result + [fsItalic];
          if Pos('fsUnderline', S) > 0 then
             Result := Result + [fsUnderline];
          if Pos('fsStrikeout', S) > 0 then
             Result := Result + [fsStrikeout];
     end;

begin
     L := TStringList.Create;
     try
        if FlatString then
           L.Text := FH.SubstituiQuebras(S, False)
        else
           L.Text := S;

        Result := TFont.Create;

        for I := 0 to L.Count - 1 do
        begin
             if GetID(L[I]) = 'Charset' then
                Result.Charset := StrToIntDef(GetVal(L[I]), 0)
             else
             if GetID(L[I]) = 'Color' then
             begin
                  try
                     Result.Color := StringToColor(GetVal(L[I]));
                  except
                     Result.Color := clWindowText;
                  end;
             end
             else
             if GetID(L[I]) = 'Height' then
                Result.Height := StrToIntDef(GetVal(L[I]), -11)
             else
             if GetID(L[I]) = 'Name' then
             begin
                  Result.Name := GetVal(L[I]);
                  if Result.Name = '' then
                     Result.Name := 'MS Sans Serif';
             end
             else
             if GetID(L[I]) = 'Pitch' then
                Result.Pitch := GetPitch
             else
             if GetID(L[I]) = 'Size' then
                Result.Size := StrToIntDef(GetVal(L[I]), 8)
             else
             if GetID(L[I]) = 'Style' then
                Result.Style := GetStyle;
        end;
        if (Result = nil) or (L.Count = 0) then
           Result := PDefault;
     finally
        L.free;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetDirSis: string;
begin
     Result := FH.AdicionaDelimitador(ExtractFilePath(Application.ExeName));
end;

//-------------------------------------------------------------------------------------------------------------------
function DuplicaArquivo(const ArqOrg, ArqDst: string; const ASobrepor: Boolean = false): Boolean;
begin
  if (FileExists(ArqDst)) and (not ASobrepor) then
    raise Exception.CreateFmt('Não foi possível criar o arquivo [ %s ] em [ %s ]', [ ExtractFileName(ArqDst), ExtractFilePath(ArqDst) ]);

  Result := Windows.CopyFile(PChar(ArqOrg), PChar(ArqDst), not ASobrepor);
end;

//-------------------------------------------------------------------------------------------------------------------
function RemoveExtensao(const S: string): string;
const
     E = '.ZAX';
begin
     Result := ChangeFileExt(S, E);
     Result := LeftStr(Result, Pos(E, Result) - 1);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ChamaPainelControle_Certificados;
begin
     ShellExecute(Application.Handle, 'open', 'certmgr.msc', '', nil, sw_shownormal);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ChamaPainelControle_Sistema;
begin
     ShellExecute(Application.Handle, 'open', 'control.exe', 'sysdm.cpl', nil, sw_shownormal);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ChamaPainelControle_ConfigRegionais;
begin
     ShellExecute(Application.Handle, 'open', 'control.exe', 'intl.cpl', nil, sw_shownormal);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure VerificaFmtDataWindows;
begin
     if Uppercase(FH.FormatoDataPadrao) = 'DD/MM/YYYY' then
        exit;

     FH.PRMsg_AT('Este sistema requer formatação de data no formato DD/MM/AAAA.'#13+
             'Altere as Configurações Regionais do Painel de Controle.');

     FH.ChamaPainelControle_ConfigRegionais;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure Explorar(const Caminho: string);
begin
     ShellExecute(application.Handle, 'explore', PChar(Caminho), nil, nil, SW_SHOWNORMAL);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure Executar(const CaminhoAplicativo: string);
begin
     ShellExecute(application.Handle, 'open', PChar(CaminhoAplicativo), nil, nil, SW_SHOWNORMAL);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure EnviarEmail(const Endereco: string);
var
     E: PChar;
begin
     try
        FH.SetaCursorAmp;
        E := PChar('mailto:' + Trim(Endereco));
        ShellExecute(Application.Handle, 'Open', E, nil, nil, SW_SHOWNORMAL);
     finally
        FH.SetaCursorDef;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure CriaLista(var L: TStrings; const pTexto: string = '');
begin
     L := TStringList.Create;
     L.Text := pTexto;
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaString(const S: string; PChr: array of string): string;
var
     I: integer;
begin
     Result := S;
     for I := Low(PChr) to High(PChr) do
         while Pos(PChr[I], Result) > 0 do
               Delete(Result, Pos(PChr[I], Result), Length(PChr[I]));
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaTagsHTML(const S: string): string;
begin
   result := FH.LimpaString(S, ['<hr>', '<b>', '</b>', '<br>', '</br>', '<bold>', '</bold>', '<strong>', '</strong>']);
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaChrNaoImprimiveis(const ATexto: string): string;
var
     i: Integer;
begin
     Result := ATexto;
     for i := 0 to 31 do
         Result := FH.LimpaString(Result, [Chr(i)]);
     for i := 127 to 191 do
         Result := FH.LimpaString(Result, [Chr(i)]);
     for i := 197 to 198 do
         Result := FH.LimpaString(Result, [Chr(i)]);

     Result := FH.LimpaString(Result, [Chr(208)]);

     for i := 215 to 216 do
         Result := FH.LimpaString(Result, [Chr(i)]);
     for i := 221 to 223 do
         Result := FH.LimpaString(Result, [Chr(i)]);
     for i := 229 to 230 do
         Result := FH.LimpaString(Result, [Chr(i)]);

     Result := FH.LimpaString(Result, [Chr(240)]);
     for i := 247 to 248 do
         Result := FH.LimpaString(Result, [Chr(i)]);
     for i := 253 to 255 do
         Result := FH.LimpaString(Result, [Chr(i)]);
end;

//-------------------------------------------------------------------------------------------------------------------
function StrParaNum(const S: string; PDefault: Extended = MinExtended): Extended;
begin
     if not TextToFloat(PChar(FH.LimpaString(Trim(S), ['.'])), Result, fvExtended) then
        if PDefault = MinExtended then
           raise Exception.CreateFmt('''%s'' não é um valor válido', [S])
        else
            Result := PDefault;
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaEspacos(const S: string): string;
begin
     Result := FH.LimpaString(S, [FH.UM_ESPACO]);
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaPonto(const S: string): string;
begin
     Result := FH.LimpaString(S, ['.']);
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaVirgula(const S: string): string;
begin
     Result := FH.LimpaString(S, [',']);
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaQuebras(const S: string; const PSubChar: string = ' '): string;
begin
     Result := StringReplace(StringReplace(S, FH.HEX_CRETURN, PSubChar, [rfReplaceAll]), FH.HEX_LINEFEED, PSubChar, [rfReplaceAll]);
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaQuebrasTrim(const S: string): string;
begin
     Result := StringReplace(S     , FH.HEX_CRETURN , ' ', [rfReplaceAll]);
     Result := StringReplace(Result, FH.HEX_LINEFEED, ' ', [rfReplaceAll]);
     Result := Trim(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function TrimQuebras(const S: string): string;
begin
     Result := Trim(FH.TrimX(FH.TrimX(S, FH.HEX_CRETURN), FH.HEX_LINEFEED));
end;

//-------------------------------------------------------------------------------------------------------------------
function SubstituiQuebras(const pTexto: string; const Tipo: TTipoSubstituicaoQuebra): string;
begin
     if Tipo = BreakParaStr then
        Result := StringReplace(pTexto, FH.HEX_CRLF, FH.STRBR, [rfReplaceAll])
     else
        Result := StringReplace(pTexto, FH.STRBR, FH.HEX_CRLF, [rfReplaceAll]);
end;

//-------------------------------------------------------------------------------------------------------------------
function SubstituiQuebras(const pTexto: string; const pTrocar: Boolean): string;
begin
     if pTrocar then
        Result := StringReplace(pTexto, FH.HEX_CRLF, FH.STRBR, [rfReplaceAll])
     else
        Result := StringReplace(pTexto, FH.STRBR, FH.HEX_CRLF, [rfReplaceAll]);
end;

//-------------------------------------------------------------------------------------------------------------------
function CopyPos(const PStr, PSubStr: string; const PTrim: Boolean = true): string;
begin
  if FH.PosStr(PSubStr, PStr) > 0 then
    Result := Copy(PStr, 1, FH.PosStr(PSubStr, PStr)-1)
  else
    Result := PStr;
  if PTrim then
    Result := Trim(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function CopyPosSeContem(const PStr, PSubStr: string; const PTrim: Boolean = true): string;
begin
  Result := '';
  if FH.PosStr(PSubStr, PStr) > 0 then
    Result := Copy(PStr, 1, FH.PosStr(PSubStr, PStr)-1);
  if PTrim then
    Result := Trim(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function StrScan(const PStr: string; Chr: AnsiChar; PInit: integer = 1): string;
var
  P: PAnsiChar;
begin
  Result := '';
  P := SysUtils.StrScan(PAnsiChar(PStr), Chr);
  if P <> nil then
  begin
    Result := string(P);
    if PInit > 1 then
      Result := Copy(Result, PInit, MaxInt);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtNum(pVal: Extended; pDec: Byte = 2): string;
begin
  Result := FloatToStrF(pVal, ffNumber, 14, pDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtFix(pVal: Extended; pDec: Byte = 2): string;
begin
  Result := FloatToStrF(pVal, ffFixed, 14, pDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtNumStr(pVal: string; pDec: Byte = 2; PDefault: Extended = 0): string;
begin
  Result := FloatToStrF(StrToFloatDef(pVal, PDefault), ffNumber, 14, pDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtFixStr(pVal: string; pDec: Byte = 2; PDefault: Extended = 0): string;
begin
  Result := FloatToStrF(StrToFloatDef(pVal, PDefault), ffFixed, 14, pDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtNumParaFix(pVal: string; pDec: Byte = 2; PDefault: Extended = 0): string;
begin
  Result := FloatToStrF(StrToFloatDef(FH.LimpaString(pVal, [FH.SeparadorMilhar, FH.HEX_CRLF]), PDefault), ffFixed, 14, pDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function StrToFloatFix(pVal: string): Extended;
begin
  Result := StrToFloat(FH.FmtNumParaFix(pVal));
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtValSQL(pVal: Extended): string;
begin
    Result := StringReplace(FloatToStr(pVal), FH.SeparadorDecimal, '.', []);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetValSql(const pValor: string; const pUpperCase: Boolean): string;
begin
     Result := quotedStr(pValor);
     if pUpperCase then
        Result := AnsiUpperCase(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetValSql(const pValor: string): string;
begin
     Result := quotedStr(pValor);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetValSql(const pValor: Extended): string;
begin
     Result := FH.FmtValSQL(pValor);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetValSql(const pValor: TDateTime): string;
begin
     Result := QuotedStr(stringReplace(datetostr(pValor),'/','.',[rfReplaceAll]));
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtInt(pVal: int64): string;
begin
     Result := FloatToStrF(pVal, ffNumber, 14, 0);
end;

//-------------------------------------------------------------------------------------------------------------------
function DiaAtual: integer;
begin
  Result := DayOf(Today);
end;

//-------------------------------------------------------------------------------------------------------------------
function MesAtual: integer;
begin
  Result := MonthOf(Today);
end;

//-------------------------------------------------------------------------------------------------------------------
function AnoAtual: integer;
begin
  Result := CurrentYear;
end;

//-------------------------------------------------------------------------------------------------------------------
function DiaAtualStr: string;
begin
  Result := FH.StrZero(DayOf(Today), 2);
end;

//-------------------------------------------------------------------------------------------------------------------
function MesAtualStr: string;
begin
  Result := FH.StrZero(MonthOf(Today), 2);
end;

//-------------------------------------------------------------------------------------------------------------------
function AnoAtualStr: string;
begin
  Result := FH.StrZero(CurrentYear, 4);
end;

//-------------------------------------------------------------------------------------------------------------------
function UltimoDiaAnoStr(const D: TDateTime): string;
begin
     Result := DateToStr(RecodeDate(D, YearOf(D), 12, 31));
end;

//-------------------------------------------------------------------------------------------------------------------
function PrimeiroDiaAnoStr(const D: TDateTime): string;
begin
     Result := DateToStr(RecodeDate(D, YearOf(D), 1, 1));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetMesStr(const PData: TDateTime = 0): string;
var
  D: TDateTime;
begin
  D := PData;
  if D = 0 then
    D := Date;
  Result := FormatDateTime('mm', D);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetMesStr(const PData: string): string;
begin
  Result := FormatDateTime('mm', StrToDate(PData));
end;

//-------------------------------------------------------------------------------------------------------------------
function GetMesAno(const PData: TDateTime = 0): string;
var
  D: TDateTime;
begin
  D := PData;
  if D = 0 then
    D := Date;
  Result := FormatDateTime('mm/yyyy', D);
end;

//-------------------------------------------------------------------------------------------------------------------
function GetMesAno(const PData: string): string;
begin
  Result := FormatDateTime('mm/yyyy', StrToDate(PData));
end;

//-------------------------------------------------------------------------------------------------------------------
function GetAnoMes(const PData: TDateTime = 0): string;
var
  D: TDateTime;
begin
  D := PData;
  if D = 0 then
    D := Date;
  Result := FormatDateTime('yyyy/mm', D);
end;

//-------------------------------------------------------------------------------------------------------------------
function GetAnoMes(const PData: string): string;
begin
  Result := FormatDateTime('yyyy/mm', StrToDate(PData));
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaDataMesAno(const PMesAno: string; const PDia: Smallint = 1): TDateTime;
var
  M, A, D: integer;
begin
  M := StrToInt(FH.CopyPos(PMesAno, '/'));
  A := StrToInt(Copy(PMesAno, Pos('/', PMesAno) + 1, 4));
  D := PDia;
  if D = -1 then
    D := FH.UltimoDia(A, M);
  Result := EncodeDate(A, M, D);
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaDataStrMesAno(const PMesAno: string; const PDia: Smallint = 1): string;
begin
  Result := DateToStr(FH.MontaDataMesAno(PMesAno, PDia));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetAnoMesInt(const PData: TDateTime = 0): string;
var
  D: TDateTime;
begin
  D := PData;
  if D = 0 then
    D := Date;
  Result := FormatDateTime('yyyymm', D);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetAnoMesInt(const PData: string): string;
begin
  Result := FormatDateTime('yyyymm', StrToDate(PData));
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaDataAnoMesInt(const PAnoMes: string; const PDia: Smallint = 1): TDateTime;
begin
  Result := EncodeDate(StrToInt(LeftStr(PAnoMes, 4)), StrToInt(FH.CopyInvertido(PAnoMes, 1, 2)), PDia);
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaDataStrAnoMesInt(const PAnoMes: string; const PDia: Smallint = 1): string;
begin
  Result := DateToStr(FH.MontaDataAnoMesInt(PAnoMes, PDia));
end;

//-------------------------------------------------------------------------------------------------------------------
function UltimoDia(const PData: TDateTime = 0): integer;
var
  D: TDateTime;
begin
  D := PData;
  if D = 0 then
    D := Date;
  Result := FH.UltimoDia(YearOf(D), MonthOf(D));
end;

//-------------------------------------------------------------------------------------------------------------------
function UltimoDia(const PData: string): integer;
var
  D: TDateTime;
begin
  D := StrToDate(PData);
  Result := FH.UltimoDia(YearOf(D), MonthOf(D));
end;

//-------------------------------------------------------------------------------------------------------------------
function PosStr(Substr, Str: string): integer;
begin
  Result := AnsiPos(AnsiLowerCase(Substr), AnsiLowerCase(Str));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaCaptionLbl(PLabel: TLabel; const PCaption: string; const PEspacos: integer = 2);
var
  M: string;
begin
  M := FH.Espacos(PEspacos);
  with PLabel do
  begin
    if Pos(':', HelpKeyword) = 0 then
      M := ':' + M;
    M := '%s' + M + '%s';
    if not FH.StrInvalida(HelpKeyword) then
      Caption := Format(M, [HelpKeyword, PCaption])
    else
      Caption := PCaption;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaContainer(PContainer: TWinControl);
var
  I: integer;
begin
  try
    with PContainer do
    begin
      for I := 0 to ControlCount - 1 do
      begin
        if (Controls[I] is TLabel) then
        begin
          case Controls[I].Tag of
            9: TLabel(Controls[I]).Caption := '';
            8: SetaCaptionLbl(TLabel(Controls[I]), '', 1);
          end;
        end;
             if Controls[I] is TEdit then TEdit(Controls[I]).Clear
        else if Controls[I] is TCustomMaskEdit then TCustomMaskEdit(Controls[I]).Clear
        else if Controls[I] is TMemo then TMemo(Controls[I]).Lines.Clear
        else if Controls[I] is TRichEdit then TRichEdit(Controls[I]).Lines.Clear
        else if Controls[I] is TCheckBox then TCheckBox(Controls[I]).Checked := false
        else if Controls[I] is TImage then TImage(Controls[I]).Picture.Assign(nil)
        else if Controls[I] is TComboBox then TComboBox(Controls[I]).ItemIndex := -1
        else if Controls[I] is TCheckListBox then FH.SetaStatusCheckListBox(false, TCheckListBox(Controls[I]));
      end;
    end;
  except
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaContainerLabel(PContainer: TWinControl);
var
  I: integer;
begin
  try
    with PContainer do
    begin
      for I := 0 to ControlCount - 1 do
      begin
        if (Controls[I] is TLabel) then
        begin
          case Controls[I].Tag of
            9: TLabel(Controls[I]).Caption := '';
            8: SetaCaptionLbl(TLabel(Controls[I]), '', 1);
          end;
        end;
      end;
    end;
  except
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function StrInvalida(const S: string): Boolean;
begin
  Result := Length(Trim(S)) = 0;
end;

//-------------------------------------------------------------------------------------------------------------------
function StrOk(const S: string; const RemoverQuebras: Boolean = false): Boolean;
begin
     if RemoverQuebras then
        Result := Length(Trim(FH.LimpaQuebras(S))) > 0
     else
        Result := Length(Trim(S)) > 0;
end;

//-------------------------------------------------------------------------------------------------------------------
function StringListOk(SL: TStrings): Boolean;
begin
    if SL = nil then
       Result := False
    else
       Result := FH.StrOk(FH.LimpaQuebras(SL.Text));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure BloqUpdate(WC: TWinControl);
begin
  if WC <> nil then
    LockWindowUpdate(WC.Handle)
  else
    LockWindowUpdate(0);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure DesbloqUpdate;
begin
  LockWindowUpdate(0);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetMaskQtd(const PQtdDec: integer; const PPrefixo: string = '###,###,##0.'): string;
begin
  Result := PPrefixo + DupeString('#', PQtdDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetMaskNum(const PQtdDec: integer; const PPrefixo: string = '###,###,##0.'): string;
begin
  Result := PPrefixo + DupeString('0', PQtdDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function ArredondaValor(const pVal: Extended; const PDecimal: integer = 2): Extended;
begin
  Result := StrToFloat(FloatToStrF(pVal, ffFixed, 15, PDecimal));
end;

//-------------------------------------------------------------------------------------------------------------------
function ArredondaValorStr(const pVal: Extended; const PDecimal: integer = 2): string;
begin
  Result := FloatToStr(FH.ArredondaValor(pVal, PDecimal));
end;

//-------------------------------------------------------------------------------------------------------------------
function CalcPercentual(const PBase, PPercentual: double): double;
begin
  Result := ((PBase * PPercentual) / 100);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetValorExtenso(AValor: double; const AEntreAsteriscos: Boolean = False; const AMonetario: Boolean = True;
                                         const AFeminino: Boolean = False; const ASeparadorFracao: string = 'e'): string;
const
  cUnidade: array[1..9] of string = ('um', 'dois', 'três', 'quatro', 'cinco', 'seis',
                                     'sete', 'oito', 'nove');
  cDezVinte: array[1..9] of string = ('onze', 'doze', 'treze', 'quatorze', 'quinze',
                                      'dezesseis', 'dezessete', 'dezoito', 'dezenove');
  cDezena: array[1..9] of string = ('dez', 'vinte', 'trinta', 'quarenta',
                                    'cinquenta', 'sessenta', 'setenta', 'oitenta', 'noventa');
  cCentena: array[1..9] of string = ('cem', 'duzentos', 'trezentos', 'quatrocentos',
                                     'quinhentos', 'seiscentos', 'setecentos', 'oitocentos',
                                     'novecentos');

var
  vValorS, vBilhao, vMilhao, vMilhar, vCentena, vCentavo, auxStr: string;

  function RetDigitos(Digitos: string): string;
  begin
    Result := '';
    if (StrToInt(Digitos) > 100) and (StrToInt(Digitos) < 200) then
      Result := 'cento e '
    else
    if StrToInt(Digitos) > 99 then
    begin
      Result := cCentena[StrToInt(copy(Digitos, 1, 1))];
      if Copy(Digitos, 2, 2) = '00' then
        exit
      else
        Result := Result + ' e ';
    end;
    if (StrToInt(copy(Digitos, 2, 2)) > 10) and (StrToInt(copy(Digitos, 2, 2)) < 20) then
    begin
      Result := Result + cDezVinte[StrToInt(copy(Digitos, 3, 1))];
      exit;
    end;
    if (StrToInt(copy(Digitos, 2, 2)) > 9) then
      Result := Result + cDezena[StrToInt(copy(Digitos, 2, 1))];
    if (StrToInt(copy(Digitos, 3, 1)) = 0) then
      exit;
    if  (Copy(Result, (Length(Result) - 1), 1) <> 'e')
    and (Result <> '') then
      Result := Result + ' e ';

    auxStr := cUnidade[StrToInt(Copy(Digitos, 3, 1))];
    if AFeminino then
    begin
      if SameText(auxStr, 'um') then
        auxStr := 'uma'
      else
      if SameText(auxStr, 'dois') then
        auxStr := 'duas';
    end;
    Result := Result + auxStr;
  end;

begin
  Result := '';
  AValor := Abs(AValor);
  vValorS := Format('%15.2f', [AValor]);
  while Pos(' ', vValorS) > 0 do
    vValorS[Pos(' ', vValorS)] := '0';

  vBilhao := Copy(vValorS, 1, 3);
  if vBilhao <> '000' then
  begin
    if vBilhao = '001' then
      Result := 'Um bilhão '
    else
      Result := RetDigitos(vBilhao) + ' bilhões '
  end;

  vMilhao := Copy(vValorS, 4, 3);
  if vMilhao <> '000' then
  begin
    if vMilhao = '001' then
      Result := 'Um milhão '
    else
      Result := Result + RetDigitos(vMilhao) + ' milhões ';
  end;

  vMilhar := Copy(vValorS, 7, 3);
  if vMilhar <> '000' then
  begin
    if Result = '' then
      Result := RetDigitos(vMilhar) + ' mil '
    else
      Result := Result + 'e ' + RetDigitos(vMilhar) + ' mil ';
  end;

  vCentena := Copy(vValorS, 10, 3);
  if vCentena <> '000' then
  begin
    if Result = '' then
    begin
      if vCentena = '001' then
      begin
        if AMonetario then
          Result := 'Um real '
        else
        begin
          if AFeminino then
            Result := 'Uma '
          else
            Result := 'Um ';
        end;
      end
      else
      begin
        if AMonetario then
          Result := RetDigitos(vCentena) + ' reais '
        else
          Result := RetDigitos(vCentena) + ' ';
      end;
    end
    else
    begin
      if AMonetario then
        Result := Result + 'e ' + RetDigitos(vCentena) + ' reais '
      else
        Result := Result + 'e ' + RetDigitos(vCentena) + ' ';
    end;
  end
  else
  if Result <> '' then
  begin
    if AMonetario then
    begin
      if (AValor > 999999.99) and (frac(AValor / 1000000) = 0) then
        Result := Result + 'de reais '
      else
        Result := Result + 'reais ';
    end
    else
      Result := Result + ' ';
  end;

  vCentavo := '0' + Copy(vValorS, 14, 2);
  if vCentavo <> '000' then
  begin
    if AMonetario then
    begin
         if Result = '' then
           Result := RetDigitos(vCentavo) + ' centavos'
         else
           Result := Result + ASeparadorFracao + ' ' + RetDigitos(vCentavo) + ' centavos';
    end
    else
    begin
         if Result = '' then
           Result := RetDigitos(vCentavo) + ' '
         else
           Result := Result + ASeparadorFracao + ' ' + RetDigitos(vCentavo) + ' ';
    end;
    if vCentavo = '001' then
      Delete(Result, Length(Result), 1);
  end;
  Result := Trim(Result);
  try
    Result := UpperCase(Result[1]) + Copy(Result, 2, MaxInt);
  except
    //
  end;
  if AEntreAsteriscos then
    Result := '(*** ' + Result + ' ***)';
end;

//-------------------------------------------------------------------------------------------------------------------
function TrataFloat(const S: string; PDef: string = ''): string;
begin
  Result := S;
  if not FH.FloatOk(Result) then
    Result := PDef;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaComboDes(CB: TComboBox; S: string; PSep: string = ' ');
var
  I: integer;
  A, B: string;
begin
  S := AnsiLowerCase(Trim(S));
  with CB do
  begin
    ItemIndex := -1;
    if S = '' then
      exit;
    B := '';
    for I := 0 to Items.Count - 1 do
    begin
      A := Copy(Items[I], Pos(PSep, Items[I]) + Length(PSep), MaxInt);
      A := AnsiLowerCase(Trim(A));
      if Length(A) = 0 then
        Continue;
      B := S;
      if (AnsiSameText(A, B)) or (LeftStr(B, Length(B)) = LeftStr(A, Length(B))) then
      begin
        ItemIndex := I;
        Break;
      end;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaComboVal(CB: TComboBox; const S: string; const Valores: array of string; const default: Integer = -1);
var
     i, a: integer;
begin
     a := 0;
     for i := Low(Valores) to High(Valores) do
     begin
          if AnsiSameText(S, Valores[i]) then
          begin
               CB.ItemIndex := a;
               Exit;
          end;
          Inc(a);
     end;
     CB.ItemIndex := default;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaComboCod(CB: TComboBox; S: string; PSep: string = ' ');
var
  I: integer;
  A, B: string;
begin
  S := AnsiLowerCase(Trim(S));
  with CB do
  begin
    ItemIndex := -1;
    if S = '' then
      exit;
    B := '';
    for I := 0 to Items.Count - 1 do
    begin
      if  (Pos(PSep, Items[I]) = 0)
      and (Length(S) = Length(Items[I])) then
        A := Items[I]
      else
        A := Copy(Items[I], 1, Pos(PSep, Items[I]) - Length(PSep));
      A := AnsiLowerCase(Trim(A));
      if Length(A) = 0 then
        Continue;
      B := S;
      if AnsiSameText(A, B) then
      begin
        ItemIndex := I;
        Break;
      end;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function FormataCNPJCPF(const PCode: string): string;
begin
  Result := StrInteiro(PCode);
  while (Length(Result) < 14) and (Length(Result) > 11) do
    Result := '0' + Result;
  if Length(Result) = 14 then
  begin
    Insert('.', Result, 3);
    Insert('.', Result, 7);
    Insert('/', Result, 11);
    Insert('-', Result, 16);
  end
  else
  if Length(Result) = 11 then
  begin
    Insert('.', Result, 4);
    Insert('.', Result, 8);
    Insert('-', Result, 12);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaCNPJCPF(const Codigo: string): string;
begin
  Result := StrInteiro(Codigo);
  while (Length(Result) < 14) and (Length(Result) > 11) do
    Result := '0' + Result;
  if Length(Result) = 14 then
  begin
    Insert('.', Result, 3);
    Insert('.', Result, 7);
    Insert('/', Result, 11);
    Insert('-', Result, 16);
  end
  else
  if Length(Result) = 11 then
  begin
    Insert('-', Result, 10);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerZero(const pValor: Extended; const PDefault: Extended = 1): Extended;
begin
     Result := pValor;
     if FH.FmtFix(Result)='0,00' then
        Result := PDefault;
end;

//-------------------------------------------------------------------------------------------------------------------
function SafeDiv(const PDividendo, PDivisor: Extended; const PDivisorDefault: Extended = 1): Extended;
begin
     Result := PDividendo / IfThen(IsZero(PDivisor), PDivisorDefault, PDivisor);
end;

//-------------------------------------------------------------------------------------------------------------------
function TrataDivZero(const PDividendo, PDivisor: Extended; const ResultadoQuandoZero: Extended = 0): Extended;
begin
    if ZeroOk(PDivisor) then
       Result := ResultadoQuandoZero
    else
       Result := PDividendo / PDivisor;
end;

//-------------------------------------------------------------------------------------------------------------------
function SetaUpper(const pTexto: string; const PTotal: integer = -1): string;
begin
     Result := TrimLeft(pTexto);
     if PTotal < 0 then
        Result := AnsiUpperCase(Result)
     else
     if PTotal > 0 then
        Result := AnsiUpperCase(Copy(Result, 1, PTotal)) + Copy(Result, PTotal + 1, MaxInt);
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtFloatStr(pVal: Extended; PTamString: integer; pDec: Byte = 2): string;
begin
  if pVal < 0 then
  begin
      Result := FH.LimpaString(FH.FmtFix(Abs(pVal), pDec), [FH.SeparadorDecimal]);
      Result := '-' + FH.StrZero(Result, PTamString - 1);
  end
  else
  begin
      Result := FH.LimpaString(FH.FmtFix(pVal, pDec), [FH.SeparadorDecimal]);
      Result := FH.StrZero(Result, PTamString);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtFloatStr(pVal: string; PTamString: integer; pDec: Byte = 2): string;
begin
  Result := FH.LimpaString(pVal, [FH.SeparadorMilhar]);
  Result := FH.FmtFloatStr(StrToFloatDef(Result, 0), PTamString, pDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function PrimeiroDiaMes(const PData: TDateTime = 0): TDateTime;
var
  D: TDateTime;
begin
  D := Date;
  if PData <> 0 then
    D := PData;
  Result := EncodeDate(YearOf(D), MonthOf(D), 1);
end;

//-------------------------------------------------------------------------------------------------------------------
function PrimeiroDiaMesStr(const PData: TDateTime = 0): string;
var
  D: TDateTime;
begin
  D := Now;
  if PData <> 0 then
    D := PData;
  Result := FormatDateTime('01/mm/yyyy', D);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure FmtFloatLabel(var PLabel: TLabel; const pValor: Extended; const PCaption: string = ''; const PThousandSeparator: Boolean = true;
  const pDec: smallint = 2);
var
  F: TFloatFormat;
begin
  F := ffNumber;
  if not PThousandSeparator then
    F := ffFixed;
  if PCaption = '' then
    PLabel.Caption := FloatToStrF(pValor, F, 14, pDec)
  else
    PLabel.Caption := Format(PCaption, [FloatToStrF(pValor, F, 14, pDec)]);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure FmtIntLabel(var PLabel: TLabel; const pValor: integer; const PCaption: string = ''; const PThousandSeparator: Boolean = true);
var
  F: TFloatFormat;
begin
  F := ffNumber;
  if not PThousandSeparator then
    F := ffFixed;
  if PCaption = '' then
    PLabel.Caption := FloatToStrF(pValor, F, 14, 0)
  else
    PLabel.Caption := Format(PCaption, [FloatToStrF(pValor, F, 14, 0)]);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniGera(var L: TStrings; const PConteudo: string);
var
  I: integer;
begin
  L := nil;
  L := TStringList.Create;
  L.Text := PConteudo;
  I := 0;
  while I < L.Count do
  begin
    if (not AnsiContainsText(L[I], '=')) and
       (not AnsiContainsText(L[I], ']')) and
       (not AnsiContainsText(L[I], '[')) then
      L.Delete(I)
    else
      Inc(I);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniGrava(var L: TStrings; const pNomeArq: string);
begin
  L.SaveToFile(pNomeArq);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniDeletaSec(var L: TStrings; const PSecao: string);
var
  I, J: integer;
begin
  J := L.IndexOf('[' + PSecao + ']');
  if J > -1 then
  begin
    I := J + 1;
    while I < L.Count do
    begin
      // não há chaves dentro da seção
      if (Pos('[', L[I]) > 0) and (Pos(']', L[I]) > 0) then
        Break;
      // a seção é a última da lista
      if I = (L.Count - 1) then
      begin
        L.Delete(I);
        Break;
      end;
      L.Delete(I);
    end;
    L.Delete(J);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniDeletaIdent(var L: TStrings; const PSecao, PIdent: string);
var
  I, J: integer;
begin
  J := L.IndexOf('[' + PSecao + ']');
  if J = -1 then
    exit // seção não existe
  else
  begin
    for I := J + 1 to L.Count - 1 do
    begin
      // fim da seção
      if (Pos('[', L[I]) > 0) and (Pos(']', L[I]) > 0) then
        exit;
      if AnsiSameText(PIdent, Trim(Copy(L[I], 1, Pos('=', L[I]) - 1))) then
      begin
        // chave encontrada dentro da seção
        L.Delete(I);
        exit;
      end;
      // fim da lista
      if I = (L.Count - 1) then
        exit;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function IniExisteSec(var L: TStrings; const PSecao: string): Boolean;
begin
     Result := L.IndexOf('[' + PSecao + ']') > -1;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniGravaStr(var SL: TStrings; const PSecao, PIdent, pValor: string);
var
     i, vPosSec, cc: integer;
begin
     vPosSec := SL.IndexOf('[' + FH.SeSenao(PSecao = '', 'Geral', PSecao) + ']');
     if vPosSec = -1 then
     begin
          // a seção e a chave não existem
          SL.Add('[' + FH.SeSenao(PSecao = '', 'Geral', PSecao) + ']');
          SL.Add(PIdent + '=' + pValor);
     end
     else
     begin
          cc := 0;
          for i := vPosSec + 1 to SL.Count - 1 do
          begin
               Inc(cc);
               if (Pos('[', SL[i]) > 0) and (Pos(']', SL[i]) > 0) then
               begin
                    if (pos('=', SL[i]) > 0) and (pos('=', SL[i]) > Pos('[', SL[i])) then
                    begin
                         if i = vPosSec + 1 then // não há chaves dentro da seção
                            SL.Add(PIdent + '=' + pValor)
                         else
                            SL.Insert(i, PIdent + '=' + pValor);
                         Break;
                    end;
               end;
               // a chave já existe dentro da seção
               if AnsiSameText(PIdent, Trim(Copy(SL[i], 1, Pos('=', SL[i]) - 1))) then
               begin
                    SL.Strings[i] := PIdent + '=' + pValor;
                    Break;
               end;
               // a seção é a última da lista
               if i = (SL.Count - 1) then
               begin
                    SL.Add(PIdent + '=' + pValor);
                    Break;
               end;
          end;
          if cc = 0 then
             SL.Add(PIdent + '=' + pValor);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniGravaInt(var L: TStrings; const PSecao, PIdent: string; const pValor: integer);
begin
  FH.IniGravaStr(L, PSecao, PIdent, IntToStr(pValor));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniGravaNum(var L: TStrings; const PSecao, PIdent: string; const pValor: Extended);
begin
  FH.IniGravaStr(L, PSecao, PIdent, FloatToStr(pValor));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniGravaBln(var L: TStrings; const PSecao, PIdent: string; const pValor: Boolean);
begin
  FH.IniGravaStr(L, PSecao, PIdent, BoolToStr(pValor));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IniGravaData(var L: TStrings; const PSecao, PIdent: string; const pValor: TDateTime);
begin
  FH.IniGravaStr(L, PSecao, PIdent, DateToStr(pValor));
end;

//-------------------------------------------------------------------------------------------------------------------
function IniLeStr(var L: TStrings; const PSecao, PIdent: string; const PDefault: string = ''): string;
var
     I, J: integer;
begin
     Result := PDefault;
     J := L.IndexOf('[' + FH.SeSenao(PSecao = '', 'Geral', PSecao) + ']');
     if J = -1 then
        exit // seção não existe
     else
     begin
          for I := J + 1 to L.Count - 1 do
          begin
               // fim da seção
               if (LeftStr(Trim(L[I]), 1) = '[') and (Pos(']', L[I]) > 0) then
                  exit;
               if AnsiSameText(PIdent, Trim(Copy(L[I], 1, Pos('=', L[I]) - 1))) then
               begin
                    // chave encontrada dentro da seção
                    Result := Trim(Copy(L[I], Pos('=', L[I]) + 1, MaxInt));
                    exit;
               end;
               // fim da lista
               if I = (L.Count - 1) then
                  exit;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function IniLeInt(var L: TStrings; const PSecao, PIdent: string; const PDefault: integer): integer;
begin
  Result := StrToIntDef(FH.IniLeStr(L, PSecao, PIdent), PDefault);
end;

//-------------------------------------------------------------------------------------------------------------------
function IniLeNum(var L: TStrings; const PSecao, PIdent: string; const PDefault: Extended): Extended;
begin
  Result := StrToFloatDef(FH.IniLeStr(L, PSecao, PIdent), PDefault);
end;

//-------------------------------------------------------------------------------------------------------------------
function IniLeBln(var L: TStrings; const PSecao, PIdent: string; const PDefault: Boolean): Boolean;
begin
  Result := StrToBoolDef(FH.IniLeStr(L, PSecao, PIdent), PDefault);
end;

//-------------------------------------------------------------------------------------------------------------------
function IniLeData(var L: TStrings; const PSecao, PIdent: string; const PDefault: TDateTime): TDateTime;
begin
  Result := StrToDateDef(FH.IniLeStr(L, PSecao, PIdent), PDefault);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaComboIndex(CB: TComboBox; const S: string; const IndexDefault: Integer = -1);
var
  I: integer;
  b: Boolean;
begin
  b := False;
  with CB do
    for I := 0 to Items.Count - 1 do
      if AnsiSameText(Items[I], S) then
      begin
        ItemIndex := I;
        b := True;
        exit;
      end;
    if not b then
       cb.ItemIndex := IndexDefault;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure DeletaArquivoComMascara(FR: TForm; const PDir, PMask: string);
var
  F: TFileListBox;
  I: integer;
begin
  try
    F := TFileListBox.Create(F);
    F.Parent := FR;
    F.Visible := false;
    F.Directory := ExtractFilePath(PDir);
    F.Mask := PMask;
    for I := 0 to F.Items.Count - 1 do
      SysUtils.DeleteFile(FH.AdicionaDelimitador(F.Directory) + F.Items[I]);
  finally
    F.Free;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure HideFR(FR: TForm);
var  ii: Integer;
begin
     if FR.Visible then
        FR.Hide;
     for ii := 0 to Screen.FormCount-1 do
         if  (Screen.Forms[ii] <> Application.MainForm)
         and (Screen.Forms[ii].Owner <> nil)
         and (not AnsiSameText(Screen.Forms[ii].ClassName, 'TJvFormDesktopAlert')) then
             if Screen.Forms[ii].Visible then
                Screen.Forms[ii].Hide;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ShowFR(FR: TForm);
var  ii: Integer;
begin
     for ii := 0 to Screen.FormCount-1 do
         if  (Screen.Forms[ii] <> Application.MainForm)
         and (Screen.Forms[ii].Owner <> nil)
         and (not AnsiSameText(Screen.Forms[ii].ClassName, 'TJvFormDesktopAlert')) then
             Screen.Forms[ii].Show;
     FR.Show;
end;

//-------------------------------------------------------------------------------------------------------------------
function PixelParaMm(const pValor: integer): double;
const
  PIXEL_POR_MILIMETRO   = 3.50;
begin
  Result := pValor / PIXEL_POR_MILIMETRO;
end;

//-------------------------------------------------------------------------------------------------------------------
function MmParaPixel(const pValor: double): integer;
const
  PIXEL_POR_MILIMETRO   = 3.50;
begin
  Result := Round(pValor * PIXEL_POR_MILIMETRO);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetPalavra(const S: string; const PQuant: integer): string;
var
  P: string;
  I, T: integer;
begin
  Result := '';
  P := Trim(S) + FH.UM_ESPACO;
  T := 0;
  if Length(P) < 2 then
    exit;
  for I := 1 to Length(P) do
  begin
    if IsValidIdent(P[I])
    or (P[I] in ['0'..'9'])
    or (P[I] in [#192..#255]) then
      Result := Result + P[I]
    else
    if RightStr(Result, 1) <> FH.UM_ESPACO then
    begin
      Result := Result + FH.UM_ESPACO;
      Inc(T);
      if T = PQuant then
        Break;
    end;
  end;
  Result := Trim(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaDataFormatada(const PDataOriginal, PDisplayFormat: string): string;
var
  D: string;
begin
  D := PDataOriginal;

  if AnsiSameText(PDisplayFormat, 'ddmmyyyy') then
  begin
       System.Insert('/', D, 3);
       System.Insert('/', D, 6);
  end
  else
  if AnsiSameText(PDisplayFormat, 'ddmmyy') then
  begin
       System.Insert('/', D, 3);
       System.Insert('/', D, 6);
  end
  else
  if AnsiSameText(PDisplayFormat, 'yyyymmdd') then
    D := Copy(D,7,2)+'/'+Copy(D,5,2)+'/'+Copy(D,1,4);

  if not FH.DataOk(D) then
    D := '';
  Result := D;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GeraCDSInativo(POrigem: TDataSet; CDS: TClientDataSet);
var  I: integer;
     t: TFieldType;
begin
     CDS.Close;
     CDS.FieldDefs.Clear;
     with POrigem.FieldDefs do
          for I := 0 to Count - 1 do
          begin
               if Items[I].DataType = ftLargeInt then
               begin
                    t := ftLargeint;
                    CDS.FieldDefs.Add(Items[I].Name, t, Items[I].Size);
               end
               else
               if Items[I].DataType = ftBCD then
               begin
                    t := ftFloat;
                    CDS.FieldDefs.Add(Items[I].Name, t);
               end
               else
               begin
                    t := Items[I].DataType;
                    CDS.FieldDefs.Add(Items[I].Name, t, Items[I].Size);
               end;
          end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GeraCDS(POrigem: TDataSet; CDS: TClientDataSet);
begin
     FH.GeraCDSInativo(POrigem, CDS);
     CDS.CreateDataSet;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ClonaUm(pOrigem, pDestino: TDataSet; const pAppend: Boolean; const pIgnorarCampos: String = '');
var
     i: integer;
     campo: string;
     LIgnorar: TStrings;
     ok: Boolean;
begin
     if pAppend then
        pDestino.Append;
     ok := pIgnorarCampos = '';
     if not ok then
        LIgnorar := TStringList.Create;
     try
        if not ok then
           FH.StrParaLista(pIgnorarCampos, LIgnorar);
        for i := 0 to pOrigem.FieldDefs.Count - 1 do
        begin
           campo := pOrigem.FieldDefs.Items[i].Name;
           if ok or (LIgnorar.IndexOf(campo) < 0) then
           begin
              try
                 if pOrigem.FieldDefs.Items[i].DataType = ftLargeInt then
                 begin
                    if (pOrigem.FieldByName(campo) as TLargeintField).IsNull then
                       pDestino.FieldByName(campo).Value := null
                    else
                    begin
                       try
                          (pDestino.FieldByName(campo) as TLargeintField).Value := (pOrigem.FieldByName(campo) as TLargeintField).Value;
                       except
                          pDestino.FieldByName(campo).AsString := pOrigem.FieldByName(campo).AsString;
                       end;
                    end;
                 end
                 else
                    pDestino.FieldByName(campo).Value := pOrigem.FieldByName(campo).Value;
              except
                 //
              end;
           end;
        end;
     finally
        if not ok then
           LIgnorar.Free;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ClonaTudo(POrigem, PDestino: TDataSet; const PAppend: Boolean);
begin
     POrigem.DisableControls;
     POrigem.First;
     while not POrigem.Eof do
     begin
          FH.ClonaUm(POrigem, PDestino, PAppend);
          PDestino.Post;
          POrigem.Next;
     end;
     POrigem.First;
     POrigem.EnableControls;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaFmtNum(DS: TDataSet; pCampo: string; PMask: string = '###,###,###,##0.00');
var
  F: TField;
begin
  F := DS.Fields.FindField(pCampo);
  if F = nil then
    exit;
  if not (F is TNumericField) then
    exit;
  (F as TNumericField).DisplayFormat := PMask;
end;

//-------------------------------------------------------------------------------------------------------------------
function FieldTypeParaStr(AFType: TFieldType): string;
begin
     if AFType = ftString    then result := 'String'   else
     if AFType = ftSmallInt  then Result := 'Smallint' else
     if AFType = ftInteger   then Result := 'Integer'  else
     if AFType = ftWord      then Result := 'Word'     else
     if AFType = ftBoolean   then Result := 'Boolean'  else
     if AFType = ftFloat     then Result := 'Float'    else
     if AFType = ftCurrency  then Result := 'Currency' else
     if AFType = ftDate      then Result := 'Date'     else
     if AFType = ftTime      then Result := 'Time'     else
     if AFType = ftDateTime  then Result := 'DateTime' else
     if AFType = ftBlob      then Result := 'BLOB'     else
     if AFType = ftAutoInc   then Result := 'Autoinc'  else
     if AFType = ftMemo      then Result := 'Memo'     else
     if AFType = ftGraphic   then Result := 'Graphic'  else Result := 'Desconhecido';
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaXML(FR: TForm; CDS: TClientDataSet; pNome: string = '');
var
  vName: string;
begin
  if ExtractFileName(pNome) = '' then
  begin
    vName := '';
    if FR <> nil then
      vName := FR.Name;
    pNome := vName + FH.SetaUpper(CDS.Name, 1);
  end;

  if ExtractFilePath(pNome) = '' then
    pNome := FH.SetaLocal(FH.vrgDefaultDir + FH.vrgDirCache) + pNome;

  if ExtractFileExt(pNome) = '' then
    pNome := ChangeFileExt(pNome, '.xml');

  CDS.SaveToFile(pNome, dfXML);
end;

//-------------------------------------------------------------------------------------------------------------------
function LeXML(FR: TForm; CDS: TClientDataSet; pNome: string = ''): Boolean;
begin
     if ExtractFileName(pNome) = '' then
        pNome := FR.Name + FH.SetaUpper(CDS.Name, 1);
     if ExtractFilePath(pNome) = '' then
        pNome := FH.SetaLocal(FH.vrgDefaultDir + FH.vrgDirCache) + pNome;
     if ExtractFileExt(pNome) = '' then
        pNome := ChangeFileExt(pNome, '.xml');
     Result := FileExists(pNome);
     if Result then
        CDS.LoadFromFile(pNome);
end;

//-------------------------------------------------------------------------------------------------------------------
function CarregaXML(FR: TForm; CDS: TClientDataSet; pNome: string = ''): Boolean;
var  c : TClientDataSet;
begin
     try
        c := TClientDataSet.Create(nil);
        try
           CDS.Close;
           if CDS.FieldDefs.Count > 0 then
              CDS.CreateDataSet;
           c.Name := CDS.Name;
           Result := FH.LeXML(FR, c, pNome);
           if not CDS.Active then
              FH.GeraCDS(c, CDS);
           FH.ClonaTudo(c, CDS, True);
           CDS.First;
        finally
           FreeAndNil(c);
        end;
     except
        Result := True;
        CDS.Close;
        if CDS.FieldDefs.Count > 0 then
           CDS.CreateDataSet;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function LeXMLSetaIndex(FR: TForm; CDS: TClientDataSet; pNome: string = ''): Boolean;
begin
   result := false;
   if LeXML(FR,CDS,pNome) then
     if CDS.Fields.Count > 0 then
        CDS.IndexFieldNames := CDS.Fields.Fields[0].FieldName;
   result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure HabiliaDatasets(PDataSets: array of TDataSet; PEnabled: Boolean);
var
  I: integer;
begin
  for I := Low(PDataSets) to High(PDataSets) do
    if PEnabled then
      PDataSets[I].EnableControls
    else
      PDataSets[I].DisableControls;
end;

//-------------------------------------------------------------------------------------------------------------------
function CopyMin(const PStr: string; const PTotal: integer; const PIndex: integer = 1): string;
begin
  Result := Copy(PStr, PIndex, Length(PStr) - PTotal);
end;

//-------------------------------------------------------------------------------------------------------------------
function LimpaAspas(const S: string): string;
begin
  Result := FH.LimpaString(S, [FH.ASPAS_SIMPLES, FH.ASPAS_DUPLAS]);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetConteudoArquivo(const PArquivo: string): string;
var
  L: TStrings;
begin
  Result := '';
  if (PArquivo = '') or (not FileExists(PArquivo)) then
    exit;
  L := TStringList.Create;
  try
    L.LoadFromFile(PArquivo);
    Result := L.Text;
  finally
    L.Free;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ComparaTextoFixo(const PVar, PFixo: string): Boolean;
begin
  Result := AnsiSameText(Copy(PVar, 1, Length(PFixo)), PFixo);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetUsuarioWindows: string;
var
  buffer: array[0..20] of Char;
  max: dWord;
begin
  Result := '';
  max := 120;
  if GetUserName(buffer, max) then
    Result := buffer
  else
    Result := 'Erro: ' + IntToStr(GetLastError);
end;

//-------------------------------------------------------------------------------------------------------------------
function BuscaNaLista(const AListaStr, ATexto: string): Boolean;
var
     L: TStrings;
begin
     L := TStringList.Create;
     try
        FH.StrParaLista(AListaStr, L);
        Result := L.IndexOf(ATexto) > -1;
     finally
        L.Free;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetornaItemNaLista(const AListaStr: String; AItem: Integer): String;
var
     L: TStrings;
begin
     Result := '';
     L := TStringList.Create;
     try
        FH.StrParaLista(AListaStr, L);
        if AItem < L.Count then
           Result := L[AItem];
     finally
        L.Free;
     end;
end;


//-------------------------------------------------------------------------------------------------------------------
function ProcuraNaLista(Lista: TStrings; const Texto: string): Integer;
var
    c, j, i : Integer;
    m       : TStrings;
begin
    Result := -1;
    if AnsiContainsText(Texto, FH.HEX_CRLF) then
    begin
        m := TStringList.Create;
        try
            m.Text := FH.TrimX(Texto, FH.HEX_CRLF);
            if m.Count > 0 then
            begin
                if m.Count > Lista.Count then
                   Exit
                else
                begin
                    for i := 0 to Lista.Count-1 do
                    begin
                        c := -1;
                        for j := 0 to m.Count-1 do
                        begin
                            if i+j > Lista.Count then
                               Break
                            else
                            if AnsiSameText(m[j], Lista[i+j]) then
                               inc(c)
                            else
                               Break;
                        end;
                        if c = m.Count-1 then
                        begin
                           Result := i;
                           Exit;
                        end;
                    end;
                end;
            end
            else
            begin
                for i := 0 to Lista.Count-1 do
                    if AnsiSameText(Texto, Lista[i]) then
                    begin
                        Result := i;
                        Exit;
                    end;
            end;
        finally
            FreeAndNil(m);
        end;
    end
    else
    begin
        for i := 0 to Lista.Count-1 do
            if AnsiSameText(Texto, Lista[i]) then
            begin
                Result := i;
                Exit;
            end;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaComboItemIndex(CB: TComboBox; const PIndex: integer);
var
  A: integer;
begin
  A := CB.Items.Count;
  if A = 0 then
    CB.ItemIndex := -1
  else
  begin
    Dec(A);
    if PIndex > A then
      CB.ItemIndex := A
    else
      CB.ItemIndex := PIndex;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function Match(const pTexto: string; const pValores: array of string): Boolean;
begin
     Result := AnsiMatchText(pTexto, pValores);
end;

//-------------------------------------------------------------------------------------------------------------------
function Match(const pNumero: Integer; const pValores: array of Integer): Boolean;
var
     i : Integer;
begin
     Result := false;
     for i := Low(pValores) to High(pValores) do
         if pValores[i] = pNumero then
         begin
              Result := True;
              Exit;
         end;
end;

//-------------------------------------------------------------------------------------------------------------------
function Contem(const pTexto, pSubtexto: string): Boolean;
begin
     Result := AnsiContainsText(pTexto, pSubtexto);
end;

//-------------------------------------------------------------------------------------------------------------------
function Contem(const pTexto: string; const pSubtextos: array of string): Boolean;
var
     s: string;
     a: Smallint;
begin
     Result := False;
     a := 0;
     for s in pSubtextos do
         if AnsiContainsText(pTexto, s) then
            inc(a);
     Result := (Length(pSubtextos) = a) and (Length(pSubtextos) > 0);
end;

//-------------------------------------------------------------------------------------------------------------------
function NaoContem(const pTexto, pSubtexto: string): Boolean;
begin
     Result := not AnsiContainsText(pTexto, pSubtexto);
end;

//-------------------------------------------------------------------------------------------------------------------
function Same(const S1, S2: string): Boolean;
begin
     Result := AnsiSameText(S1, S2);
end;

//-------------------------------------------------------------------------------------------------------------------
function NotSame(const S1, S2: string): Boolean;
begin
     Result := not AnsiSameText(S1, S2);
end;

//-------------------------------------------------------------------------------------------------------------------
function ContemTextoIndex(const pTexto: string; const PValores: array of string): integer;
var
  I: integer;
begin
  Result := -1;
  for I := Low(PValores) to High(PValores) do
    if AnsiContainsText(pTexto, PValores[I]) then
    begin
      Result := I;
      Break;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ContemTexto(const pTexto: string; const PValores: array of string): Boolean;
begin
  Result := FH.ContemTextoIndex(pTexto, PValores) <> -1;
end;

//-------------------------------------------------------------------------------------------------------------------
function AdicionaExtensao(const S, PExt: string): string;
begin
  Result := S;
  if ExtractFileExt(Result) <> '' then
    Result := FH.RemoveExtensao(Result);
  if RightStr(Result, 1) <> '.' then
    Result := Result + IfThen(Pos('.', PExt) = 0, '.') + PExt
  else
    Result := Result + IfThen(Pos('.', PExt) = 0, PExt, RightStr(PExt, Length(PExt) - 1));
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaEnabled(const AEnabled: Boolean; AComponentes: array of TComponent);
var
   i: integer;
begin
     for i := low(AComponentes) to high(AComponentes) do
         if AComponentes[I] is TMenuItem then
            TMenuItem(AComponentes[I]).Enabled := AEnabled
         else
         if AComponentes[I] is TControl then
            TControl(AComponentes[I]).Enabled := AEnabled;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaEnabledContainer(PContainer: TWinControl; const PEnabled: Boolean);
var
  i: integer;
begin
  for i := 0 to PContainer.ControlCount - 1 do
    PContainer.Controls[i].Enabled := PEnabled;
end;

//-------------------------------------------------------------------------------------------------------------------
function DataEntre(const PData, PMin, PMax: TDateTime): Boolean;
begin
     Result := (PData >= PMin) and (PData <= PMax);
end;

//-------------------------------------------------------------------------------------------------------------------
function UltimoDiaMes(const PData: TDateTime = 0): TDateTime;
var
  D: TDateTime;
begin
  D := Date;
  if PData <> 0 then
    D := PData;
  Result := EncodeDate(YearOf(D), MonthOf(D), FH.UltimoDia(D));
end;

//-------------------------------------------------------------------------------------------------------------------
function UltimoDiaMesStr(const PData: TDateTime = 0): string;
var
     D: TDateTime;
begin
     D := Date;
     if PData <> 0 then
        D := PData;
     Result := DateToStr(EncodeDate(YearOf(D), MonthOf(D), FH.UltimoDia(D)));
end;

//-------------------------------------------------------------------------------------------------------------------
function PrimeiroDiaMesAno(const PMesAno: string): string;
begin
     if FH.MesAnoValido(PMesAno) then
        Result := '01/' + PMesAno
     else
        Result := '';
end;

//-------------------------------------------------------------------------------------------------------------------
function UltimoDiaMesAno(const PMesAno: string): string;
begin
     if FH.MesAnoValido(PMesAno) then
        Result := FH.UltimoDiaMesStr(StrToDate('01/' + PMesAno))
     else
        Result := '';
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaSQL_IN(DS: TDataSet; const pCampo: string; const EntrePar: Boolean = true; const Espacado: Boolean = false): string;
var
     tmp: string;
begin
     Result := '';
     with DS do
     begin
          first;
          while not eof do
          begin
               tmp := FieldByName(pCampo).AsString;
               if FieldByName(pCampo) is TStringField then
                  tmp := QuotedStr(tmp);
               Result := Result + ifthen(Result > '', ',' +
                                         ifthen(Espacado, FH.UM_ESPACO)) + tmp;
               next;
          end;
          if EntrePar then
             Result := FH.EntrePar(Result);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaSQL_IN(ALista: TStrings; const ACampo: string; const AValoresEntreAspas: Boolean = false): string;
var
     cod, r, m: string;
     t: Integer;
begin
     Result := '';
     t := 0;
     r := '';
     m := '';
     for cod in ALista do
     begin
          Inc(t);
          if t > 500 then
          begin
               if r <> '' then
                  r := r + FH.CRLF + ' OR ';
               r := r + Format('(%s IN (%s))', [ACampo, m]);
               m := '';
               t := 1;
          end;
          m := m + FH.SeSenao(m <> '', ',' + FH.UM_ESPACO);
          if AValoresEntreAspas then
             m := m + QuotedStr(cod)
          else
             m := m + cod;
     end;
     if t < 500 then
     begin
          if r <> '' then
             r := r + FH.CRLF + ' OR ';
          r := r + Format('(%s IN (%s))', [ACampo, m]);
     end;
     if t = 0 then
        Result := '( ' + ACampo + ' IN (' + QuotedStr('') + ') ) '
     else
        Result := '( ' + r + ' )';
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaSQL_OR(DS: TDataSet; const pCampo: string; const pAlias: string = ''): string;
var
  tmp, vapl, sTemp, camDS, camRF: string;
  L: TStrings;
  I: Integer;
begin
  Result := '';
  L := TStringList.Create;
  try
    sTemp := pCampo;
    sTemp := StringReplace(sTemp, ';', ',', [rfReplaceAll]);
    if AnsiContainsText(pCampo, ',') then
      FH.StrParaLista(sTemp, L)
    else
      L.Add(sTemp);

    vapl := pAlias;
    if vapl > '' then
      vapl := vapl + '.';

    with DS do
    begin
      if IsEmpty then
        Exit;

      first;
      while not eof do
      begin
        if Result > '' then
          Result := Result + CRLF + ' or ';

        Result := Result + '(';

        for I := 0 to L.Count-1 do
        begin
          if AnsiContainsText(L[I], '=') then
          begin
            camDS := FH.CopyPos   (L[I], '=');
            camRF := FH.CopyPosMax(L[I], '=');
          end
          else
          begin
            camDS := L[I];
            camRF := L[I];
          end;

          tmp := FieldByName(camDS).AsString;
          if FieldByName(camDS) is TStringField then
            tmp := QuotedStr(tmp);

          if I > 0 then
            Result := Result + ' and ';

          Result := Result + vapl + camRF + ' = ' + tmp;
        end;

        Result := Result + ')';
        next;
      end;
      Result := '( ' + Result + ' )';
    end;
  finally
    FreeAndNil(L);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function GetColunaDBGrid(GR: TDBGrid; const PNomeCampo: string): TColumn;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to GR.Columns.Count - 1 do
    if AnsiSameText(GR.Columns[i].FieldName, PNomeCampo) then
    begin
      Result := GR.Columns[i];
      exit;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaBufferTeclado(FR: TForm);
var
  Msg: TMsg;
begin
  if FR = nil then
    exit;
  while PeekMessage(Msg, FR.Handle, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE or PM_NOYIELD) do
    ;
end;

//-------------------------------------------------------------------------------------------------------------------
function CopyPosMax(const PStr, PSubStr: string; const PTrim: Boolean = true): string;
var
  i: integer;
begin
  i := FH.PosStr(PSubStr, PStr);
  if i > 0 then
    Result := copy(PStr, i + Length(PSubStr), MaxInt)
  else
    Result := '';
  if PTrim then
    Result := Trim(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaBufferMouse(FR: TForm);
var
  Msg: TMsg;
begin
  if FR = nil then
    exit;
  while PeekMessage(Msg, FR.Handle, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE or PM_NOYIELD) do
    ;
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaCriptoString(const pValor: string; const pDesmontar: Boolean; const pTamanho: integer = -1): string;
const
    CNUM = '0123456789';
    CCOD = 'AJFEGXQLIS';
var
    I, J: integer;
    S, M: string;
begin
    if pDesmontar then
    begin
        J := 0;
        S := '';
        M := '';
        Result := '';
        M := pValor;
        for I := 0 to 9 do
          M := StringReplace(M, IntToStr(I), '', [rfReplaceAll]);
        for I := 65 to 90 do
          if FH.PosStr(ansiChar(I), CCOD) = 0 then
            M := StringReplace(M, ansiChar(I), '', [rfReplaceAll]);
        I := 1;
        M := Trim(M);
        while I <= Length(M) do
        begin
          S := Copy(M, I, 4);
          for J := 1 to Length(S) do
            S[J] := CNUM[FH.PosStr(S[J], CCOD)];
          J := StrToInt(S);
          J := ((J div 3) + 7) div 9;
          Result := Result + ansiChar(J);
          Inc(I, 4);
        end;
    end
    else
    begin
        J := 0;
        S := '';
        Result := '';
        for I := 1 to Length(pValor) do
        begin
          J := Ord(pValor[I]);
          J := ((J * 9) - 7) * 3;
          S := IntToStr(J);
          S := StringOfChar('0', 4 - Length(S)) + S;
          Result := Result + S;
        end;
        for I := 1 to Length(Result) do
          Result[I] := CCOD[Pos(Result[I], CNUM)];
        while Length(Result) < pTamanho do
        begin
          J := RandomRange(1, Length(Result) + 1);
          if Odd(Length(Result)) then
          begin
            S := ansiChar(65);
            while FH.PosStr(S, CCOD) > 0 do
              S := ansiChar(RandomRange(65, 90));
            Insert(S, Result, J);
          end
          else
            Insert(IntToStr(RandomRange(0, 9)), Result, J);
        end;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetTamanhoArquivo(const PArquivo: string): Integer;
var
     vAtr: TSearchRec;
begin
     FindFirst(PArquivo, faAnyFile, vAtr);
     Result := Round(vAtr.Size / 1024);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetTamanhoArquivoBytes(const PArquivo: string): Int64;
var
     vAtr: TSearchRec;
begin
     FindFirst(PArquivo, faAnyFile, vAtr);
     Result := vAtr.Size;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerItemCheckListBox(CL: TCheckListBox; const pTexto: string; const PFullItem: Boolean; const PDivisor: string = #32): Boolean;
var
  I: integer;
begin
  Result := false;
  for I := 0 to CL.Items.Count - 1 do
  begin
    if PFullItem then
    begin
      if AnsiSameText(pTexto, CL.Items[I]) then
        if CL.Checked[I] then
        begin
          Result := true;
          exit;
        end;
    end
    else
    begin
      if AnsiSameText(pTexto, FH.RetCodigoStr(CL.Items[I], PDivisor)) then
        if CL.Checked[I] then
        begin
          Result := true;
          exit;
        end;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerItemListView(LV: TListView; const pTexto: string): Boolean;
var
  I: integer;
begin
  Result := false;
  for I := 0 to LV.Items.Count - 1 do
  begin
    if AnsiSameText(pTexto, LV.Items[I].Caption) then
      if LV.Items[I].Checked then
      begin
        Result := true;
        exit;
      end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function BuscaCheckListBox(CL: TCheckListBox; const pTexto: string; const PFullItem: Boolean; const PDivisor: string = #32): Boolean;
var
  I: integer;
  temp: string;
begin
  Result := false;
  for I := 0 to CL.Items.Count - 1 do
  begin
    if PFullItem then
    begin
      if AnsiSameText(pTexto, CL.Items[I]) then
      begin
        CL.ItemIndex := I;
        Result := true;
        exit;
      end;
    end
    else
    begin
      if (PDivisor = #0) or (not AnsiContainsText(CL.Items[I], PDivisor)) then
        temp := CL.Items[I]
      else
        temp := FH.RetCodigoStr(CL.Items[I], PDivisor);
      if AnsiSameText(pTexto, LeftStr(temp, Length(pTexto))) then
      begin
        CL.ItemIndex := I;
        Result := true;
        exit;
      end;
    end;
  end;
  CL.ItemIndex := -1;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerCheckedCheckListBox(CL: TCheckListBox): Boolean;
var
  I: integer;
begin
  Result := false;
  for I := 0 to CL.Items.Count - 1 do
  begin
    if CL.Checked[I] then
    begin
      Result := true;
      exit;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerCheckedListView(LV: TListView): Boolean;
var
  I: integer;
begin
  Result := false;
  if not LV.Checkboxes then
    exit;
  if LV.Items.Count = 0 then
    exit;
  for I := 0 to LV.Items.Count - 1 do
  begin
    if LV.Items[I].Checked then
    begin
      Result := true;
      exit;
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerCheckedTodosListView(LV: TListView): Boolean;
var
  I: integer;
begin
  Result := false;
  if not LV.Checkboxes then
    exit;
  if LV.Items.Count = 0 then
    exit;
  for I := 0 to LV.Items.Count - 1 do
  begin
    if not LV.Items[I].Checked then
      exit;
  end;
  Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerCheckedTodosCheckListBox(CL: TCheckListBox): Boolean;
var
  I: integer;
begin
  Result := false;
  if CL.Items.Count = 0 then
    exit;
  for I := 0 to CL.Items.Count - 1 do
  begin
    if not CL.Checked[I] then
      exit;
  end;
  Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
function RenomeiaArquivo(const PDirArqOrigem, PDirArqDestino: string): Boolean;
begin
     Result := MoveFile(PChar(PDirArqOrigem), PChar(PDirArqDestino));
end;

//-------------------------------------------------------------------------------------------------------------------
function MoveArquivo(const POrigem, PDestino: string): Boolean;
begin
     Result := MoveFile( PChar( POrigem ), PChar( PDestino ) ) ;
end;

//-------------------------------------------------------------------------------------------------------------------
function BlockInput(fBlockIt: Boolean): Boolean;
type
  TCacheFunction = function (fBlockIt: BOOL): Boolean; stdcall;
const
  ND = 'USER32.DLL';
var
  Hnd   : THandle;
  Fpr   : TFarProc;
  fCache: TCacheFunction;
begin
  Result := true;
  Hnd := SafeLoadLibrary(nd);
  if Hnd > 0 then
  begin
    Fpr := GetProcAddress(Hnd, 'BlockInput');
    if Fpr <> nil then
    begin
      fCache := TCacheFunction(Fpr);
      Result := fCache(fBlockIt);
    end;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ValoresIdenticos(const PValor1, PValor2: extended; const pDec: Integer = 2): Boolean;
begin
  Result := FH.FmtFix(PValor1, pDec) = FH.FmtFix(PValor2, pDec);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure FreeNil(var PObj);
var
     temp: TObject;
begin
     temp := TObject(PObj);
     if temp <> nil then
     begin
          try
            FreeAndNil(temp);
            //FreeAndNil(PObj);
          except
            sleep(1);
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure FreeNil(Objs: array of TObject);
var
     i: Integer;
begin
     for i := Low(Objs) to High(Objs) do
         if Objs[i] <> nil then
            FreeAndNil(Objs[i]);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetDiaSemanaExtenso(const PDia: integer): string;
begin
  Result := 'Dia inválido!';
  case PDia of
    1: Result := 'Domingo';
    2: Result := 'Segunda-feira';
    3: Result := 'Terça-feira';
    4: Result := 'Quarta-feira';
    5: Result := 'Quinta-feira';
    6: Result := 'Sexta-feira';
    7: Result := 'Sábado';
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerSabadoOuDomingo(PData: TDatetime): Boolean;
begin
     // Sábado = 6 / Domingo = 7
     Result := DayOfTheWeek(PData) > DIASEM_SEXTA;
end;

//-------------------------------------------------------------------------------------------------------------------
function DiaUtil(PData: TDatetime): Boolean;
begin
     Result := DayOfTheWeek(PData) < DIASEM_SABADO;
end;

//-------------------------------------------------------------------------------------------------------------------
function DiaUtilProximo(PData: TDatetime): TDatetime;
begin
     while not FH.DiaUtil(PData) do
           PData := IncDay(PData, 1);
     Result := PData;
end;

//-------------------------------------------------------------------------------------------------------------------
function DiaUtilAnterior(PData: TDatetime): TDateTime;
begin
     while not FH.DiaUtil(PData) do
           PData := IncDay(PData, -1);
     Result := PData;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerificaEntradaArq(const pNomeArq: string; pCampo: TWinControl): Boolean;
begin
  Result := false;
  if FH.StrInvalida(pNomeArq) then
  begin
    FH.PrMsg_Focalize(pCampo, 'Arquivo inválido');
    exit;
  end;
  if not FileExists(pNomeArq) then
  begin
    FH.PrMsg_Focalize(pCampo, Format('Arquivo %s não existe.', [QuotedStr(pNomeArq)]));
    exit;
  end;
  Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerificaEntradaDir(const PNomeDir: string; pCampo: TWinControl): Boolean;
begin
  Result := false;
  if FH.StrInvalida(PNomeDir) then
  begin
    FH.PrMsg_Focalize(pCampo, 'Pasta inválida.');
    exit;
  end;
  if not DirectoryExists(PNomeDir) then
  begin
    FH.PrMsg_Focalize(pCampo, Format('Pasta %s não existe.', [QuotedStr(PNomeDir)]));
    exit;
  end;
  Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure CopiaParaAreaTransf(const S: string);
begin
     Clipbrd.Clipboard.SetTextBuf(PChar(S));
end;

//-------------------------------------------------------------------------------------------------------------------
function PreparaValorValido(const PStr: string; const pDec: SmallInt; const PSepMilhar: Boolean): string;
var
  vDec: SmallInt;
begin
  Result := PStr;
  if FH.StrInvalida(Result) then
  begin
    Result := FH.FmtFix(0, pDec);
    exit;
  end;
  vDec := pDec;
  if vDec < 1 then vDec := 0;
  if vDec > 0 then
    System.Insert(FH.SeparadorDecimal, Result, Length(Result) - (vDec - 1));
  Result := FH.LimpaZero(Result);
  if FH.FloatOk(Result) then
  begin
    Result := FH.FmtFix(StrToFloat(Result), vDec);
    if PSepMilhar then
      Result := FH.FmtNum(StrToFloat(Result), vDec);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GeraArqTexto(const pNomeArq, pTexto: string);
var
  L: TStrings;
begin
  L := TStringList.Create;
  try
     L.Text := pTexto;
     L.SaveToFile(pNomeArq);
  finally
    FreeAndNil(L);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function DeletaLinhasEmBranco(const pLinhas: string): string;
var
    L: TStrings;
    i: Integer;
begin
    L := TStringList.Create;
    try
       L.Text := pLinhas;
       i := 0;
       while i <= L.Count-1 do
       begin
            if FH.StrInvalida(L[i]) then
               L.Delete(i)
            else
               inc(i);
       end;
       Result := L.Text;
    finally
      L.Free;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerTeclaMovimento(const pKey: Word): Boolean;
begin
  Result := (pKey = VK_UP)
         or (pKey = VK_DOWN)
         or (pKey = VK_PRIOR)
         or (pKey = VK_NEXT)
         or (pKey = VK_HOME)
         or (pKey = VK_END)
         or (pKey = VK_LEFT)
         or (pKey = VK_RIGHT);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PrMsg_AT(const S: string; const pNegrito: Boolean = False; const pMonoEspacada: Boolean = False);
begin
     MessageDlg(S, mtWarning, [mbOK], 0);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PrMsg_AT(const S: string; const Args: array of const; const pNegrito: Boolean = False; const pMonoEspacada: Boolean = False);
begin
     MessageDlg(Format(S, Args), mtWarning, [mbOK], 0);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PrMsg_ER(const S: string);
begin
     MessageDlg(S, mtError, [mbOK], 0);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PrMsg_ER(const S: string; const Args: array of const);
begin
     MessageDlg(Format(S, Args), mtError, [mbOK], 0);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PrMsg_IN(const S: string; const pNegrito: Boolean = False; const pMonoEspacada: Boolean = False);
begin
     MessageDlg(S, mtInformation, [mbOK], 0);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PrMsg_IN(const S: string; const Args: array of const; const pNegrito: Boolean = False; const pMonoEspacada: Boolean = False);
begin
     MessageDlg(Format(S, Args), mtInformation, [mbOK], 0);
end;

//-------------------------------------------------------------------------------------------------------------------
function PrMsg_CF(const S: string; PFlag: TFlagMsgSN = 0; const pFocoBotaoSim: Boolean = True): integer;
var
    vTipo: TMsgDlgType;
    bt : TMsgDlgBtn;
    r: Integer;
begin
    case PFlag of
         0 : vTipo := mtConfirmation;
         1 : vTipo := mtError;
         2 : vTipo := mtWarning;
         3 : vTipo := mtInformation;
    else
             vTipo := mtConfirmation;
    end;
    if pFocoBotaoSim then
       bt := mbYes
    else
       bt := mbNo;
    r := MessageDlg(S, vTipo, [mbYes, mbNo], 0, bt);
    if r <> mrYes then
       Result := 0
    else
       Result := 1;
end;

//-------------------------------------------------------------------------------------------------------------------
function PrMsg_CF(const S: string; const Args: array of const; PFlag: TFlagMsgSN = 0; const pFocoBotaoSim: Boolean = True): integer;
begin
     Result := FH.PrMsg_CF(Format(S, Args), PFlag, pFocoBotaoSim);
end;

//-------------------------------------------------------------------------------------------------------------------
function PrMsg_Focalize(pCampo: TWinControl; const PMsg: string = ''; const MostrarNomeDoCampo: Boolean = false): Boolean;
var
    ss : string;
    ii : Integer;
    F  : TForm;
    L  : TLabel;
begin
    if PMsg = '' then
       ss := FH.vrgDefErrMsg
    else
       ss := PMsg;
    if MostrarNomeDoCampo and (pCampo <> nil) then
    begin
        if pCampo.Hint <> '' then
           ss := SetaMensagemValidacao(pCampo.Hint, ss)
        else
        if pCampo.Owner is TForm then
        begin
            F := pCampo.Owner as TForm;
            for ii := 0 to F.ComponentCount-1 do
            begin
                if F.Components[ii] is TLabel then
                begin
                    L := F.Components[ii] as TLabel;
                    if L.FocusControl <> nil then
                       if L.FocusControl.Name = pCampo.Name then
                       begin
                           ss := SetaMensagemValidacao(FH.LimpaString(L.Caption, ['&']), ss);
                           Break;
                       end;
                end;
            end;
        end;
    end;
    if pCampo <> nil then
    begin
         FH.Focalize(pCampo);
    end;
    FH.PrMsg_AT(ss);
    FH.SetaCursorDef;
    Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
function PrMsg_FocalizeSe(const PCondicao: Boolean; pCampo: TWinControl; const PMsg: string = ''; const MostrarNomeDoCampo: Boolean = false): Boolean;
begin
  Result := PCondicao;
  if Result then
    FH.PrMsg_Focalize(pCampo, PMsg, MostrarNomeDoCampo);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaComponentes(PCampos: array of TControl);
var
  ii: integer;
begin
  for ii := low(PCampos) to high(PCampos) do
  begin
    if PCampos[ii] is TEdit then (PCampos[ii] as TEdit).Clear else
    if PCampos[ii] is TMemo then (PCampos[ii] as TMemo).Clear else
    if PCampos[ii] is TRichEdit then (PCampos[ii] as TRichEdit).Clear else
    if PCampos[ii] is TLabel then (PCampos[ii] as TLabel).Caption := '' else
    if PCampos[ii] is TMaskEdit then (PCampos[ii] as TMaskEdit).Clear else
    if PCampos[ii] is TCustomMaskEdit then (PCampos[ii] as TCustomMaskEdit).Clear else
    if PCampos[ii] is TComboBox then (PCampos[ii] as TComboBox).ItemIndex := -1 else
    if PCampos[ii] is TCheckBox then (PCampos[ii] as TCheckBox).Checked := false else
    if PCampos[ii] is TCheckListBox then FH.SetaStatusCheckListBox(false, (PCampos[ii] as TCheckListBox)) else
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
// PTipoCampo: 0 = texto, 1 = inteiros, 2 = flutuantes, 3 = datas
function ValidaCampo(pCampo: TControl; PTipoCampo: Integer = vmStr;
                     const PDisparaMsg: Boolean = True;
                     const MostrarNomeDoCampo: Boolean = false): Boolean;
var
    i          : integer;
    vMsg, vstr : string;
    vProp      : PPropInfo;
begin
    vMsg         := vrgDefErrMsg;
    vrgDefErrMsg := MSG_DEFAULT_VALIDACAO;

    { *** CheckListBox *** }
    if pCampo is TCheckListBox then
    begin
        Result := true;
        for i := 0 to TCheckListBox(pCampo).Items.Count - 1 do
        begin
            Result := TCheckListBox(pCampo).Checked[i];
            if Result then
              Break;
        end;
        if (not Result) and (PDisparaMsg) then
        begin
            FH.PrMsg_AT('Não há itens selecionados.');
            FH.Focalize(TCheckListBox(pCampo));
        end;
    end
    else
    { *** ComboBox *** }
    if pCampo is TComboBox then
    begin
        Result := true;
        if TComboBox(pCampo).ItemIndex = -1 then
        begin
            if PDisparaMsg then
               FH.PrMsg_Focalize(TComboBox(pCampo), vMsg, MostrarNomeDoCampo);
            Result := false;
        end;
    end
    else
    { *** Edits, etc... *** }
    begin
        if AnsiSameText(RightStr(pCampo.ClassName, 4), 'EDIT') then
        begin
            // ------------------------------
            // texto normal
            // ------------------------------
            if PTipoCampo = vmStr then
            begin
                vProp := typInfo.GetPropInfo(pCampo.ClassInfo, 'Text');
                if Assigned(vProp) then
                begin
                    vstr := typInfo.GetStrProp(pCampo, vProp);
                    if vstr = '' then
                    begin
                        if PDisparaMsg then
                           FH.PrMsg_Focalize(TWinControl(pCampo), vMsg, MostrarNomeDoCampo);
                        Result := false;
                        Exit;
                    end
                    else
                    if AnsiContainsText(pCampo.ClassName, 'DATEEDIT') then
                    begin
                        if FH.DataInvalida(vstr) then
                        begin
                            if PDisparaMsg then
                               FH.PrMsg_Focalize(TWinControl(pCampo), vMsg, MostrarNomeDoCampo);
                            Result := false;
                            Exit;
                        end;
                    end;
                end;
            end
            else
            // ------------------------------
            // inteiro ou numérico
            // ------------------------------
            if (PTipoCampo = vmInt) or (PTipoCampo = vmNum) then
            begin
                vProp := typInfo.GetPropInfo(pCampo.ClassInfo, 'Value');
                if Assigned(vProp) then
                begin
                    if AnsiSameText(pCampo.ClassName, 'TcxSpinEdit') then
                       vstr := FloatToStr(typInfo.GetVariantProp(pCampo, vProp))
                    else
                       vstr := FloatToStr(typInfo.GetFloatProp(pCampo, vProp));

                    if PTipoCampo = vmInt then
                    begin
                        if FH.IntInvalido(vstr) then
                        begin
                            if PDisparaMsg then
                               FH.PrMsg_Focalize(TWinControl(pCampo), vMsg, MostrarNomeDoCampo);
                            Result := false;
                            Exit;
                        end;
                    end
                    else
                    if PTipoCampo = vmNum then
                    begin
                        if (not FH.FloatOk(vstr)) or (StrToFloatDef(vstr, 0) = 0) then
                        begin
                            if PDisparaMsg then
                               FH.PrMsg_Focalize(TWinControl(pCampo), vMsg, MostrarNomeDoCampo);
                            Result := false;
                            Exit;
                        end;
                    end;
                end
                else
                begin
                    vProp := typInfo.GetPropInfo(pCampo.ClassInfo, 'Text');
                    if Assigned(vProp) then
                    begin
                        vstr := typInfo.GetStrProp(pCampo, vProp);
                        if PTipoCampo = vmInt then
                        begin
                            if FH.IntInvalido(vstr) then
                            begin
                                if PDisparaMsg then
                                   FH.PrMsg_Focalize(TWinControl(pCampo), vMsg, MostrarNomeDoCampo);
                                Result := false;
                                Exit;
                            end;
                        end
                        else
                        if PTipoCampo = vmNum then
                        begin
                            if not FH.FloatOk(vstr) then
                            begin
                                if PDisparaMsg then
                                   FH.PrMsg_Focalize(TWinControl(pCampo), vMsg, MostrarNomeDoCampo);
                                Result := false;
                                Exit;
                            end;
                        end;
                    end;
                end;
            end
            else
            // ------------------------------
            // data
            // ------------------------------
            if PTipoCampo = vmDat then
            begin
                vProp := typInfo.GetPropInfo(pCampo.ClassInfo, 'Text');
                if Assigned(vProp) then
                begin
                    vstr := typInfo.GetStrProp(pCampo, vProp);
                    if FH.DataInvalida(vstr) then
                    begin
                        if PDisparaMsg then
                           FH.PrMsg_Focalize(TWinControl(pCampo), vMsg, MostrarNomeDoCampo);
                        Result := false;
                        Exit;
                    end;
                end;
            end;
        end;

        if pCampo is TCustomMemo then
        begin
            if TCustomMemo(pCampo).Lines.Text = '' then
            begin
                if PDisparaMsg then
                   FH.PrMsg_Focalize(TWinControl(pCampo), vMsg, MostrarNomeDoCampo);
                Result := false;
                Exit;
            end;
        end;

        Result := True;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ValidaMultiCampo(PCampos: array of TControl; PTipoCampo: array of Integer;
                                   const PDisparaMsg: Boolean = true;
                                   const MostrarNomeDoCampo: Boolean = false): Boolean;
var
    I: integer;
    V: Integer;
begin
    Result := True;
    for I := Low(PCampos) to High(PCampos) do
    begin
        if (I < Low(PTipoCampo)) or (I > High(PTipoCampo)) then
           V := vmStr
        else
           V := PTipoCampo[I];
        Result := FH.ValidaCampo(PCampos[I], V, PDisparaMsg, MostrarNomeDoCampo);
        if not Result then
           exit;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function BoolParaStr(const pValor: Boolean): string;
begin
  if pValor then
     Result := 'S'
  else
     Result := 'N';
end;

//-------------------------------------------------------------------------------------------------------------------
function StrParaBool(const pValor: string; const PDefault: Boolean = false): Boolean;
begin
  if pValor = 'S' then
     Result := true
  else
  if pValor = 'N' then
     Result := false
  else
     Result := PDefault;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetCodigoCombo(CB: TComboBox; const PCodigos: array of string; const PNaoSel: string = ''): string;
var
     i, a: integer;
begin
     Result := '';
     a := 0;
     for i := Low(PCodigos) to High(PCodigos) do
     begin
          if a = CB.ItemIndex then
          begin
               Result := PCodigos[i];
               exit;
          end;
          inc(a);
     end;
     if CB.ItemIndex = -1 then
        Result := PNaoSel;
end;

//-------------------------------------------------------------------------------------------------------------------
function SeTemInteiro(const PStr: string; const SenaoRetorne: string = ''): string;
begin
     Result := PStr;
     if FH.StrInteiro(PStr) = '' then
        Result := SenaoRetorne;
end;

//-------------------------------------------------------------------------------------------------------------------
function TemInteiro(const PStr: string): Boolean;
begin
     Result := FH.StrInteiro(PStr) <> '';
end;

//-------------------------------------------------------------------------------------------------------------------
function NaoTemInteiro(const PStr: string): Boolean;
begin
     Result := not FH.TemInteiro(PStr);
end;

//-------------------------------------------------------------------------------------------------------------------
function PreparaLike(const PStr: string; const PInicio: Boolean = True; const PFinal: Boolean = True): string;
begin
     Result := PStr;
     if AnsiContainsText(PStr, '%') then
        Result := FH.LimpaString(Result, ['%']);
     Result := AnsiDequotedStr(AnsiDequotedStr(Result, '"'), '''');
     if PFinal then
        Result := Result + '%';
     if PInicio then
        Result := '%' + Result;
     Result := QuotedStr(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function WhereAnd(const PSql: string; const PVerificarApos: string = ''; const PVerificarAte: string = ''): string;
const
     INICIO_CRITERIOS1 = '/*ini_criterios*/';
     INICIO_CRITERIOS2 = '--ini_criterios';
var
     tmpStr: string;
begin
     if  (PVerificarApos <> '')
     and (FH.Contem(PSql, PVerificarApos)) then
     begin
          tmpStr := FH.CopyPosMax(PSql, PVerificarApos);
          if  (PVerificarAte <> '')
          and (FH.Contem(tmpStr, PVerificarAte)) then
              tmpStr := FH.CopyPos(tmpStr, PVerificarAte);
     end
     else
     if FH.Contem(PSql, INICIO_CRITERIOS1)
     or FH.Contem(PSql, INICIO_CRITERIOS2) then
     begin
          if FH.Contem(PSql, INICIO_CRITERIOS1) then
             tmpStr := FH.CopyPosMax(PSql, INICIO_CRITERIOS1)
          else
             tmpStr := FH.CopyPosMax(PSql, INICIO_CRITERIOS2);
          if  (PVerificarAte <> '')
          and (FH.Contem(tmpStr, PVerificarAte)) then
              tmpStr := FH.CopyPos(tmpStr, PVerificarAte);
     end
     else
         tmpStr := PSql;

     if FH.Contem(tmpStr, 'WHERE') then
        Result := ' AND '
     else
        Result := 'WHERE ';
end;

//-------------------------------------------------------------------------------------------------------------------
function AdicionaQuebra(const pTexto: string): string;
begin
     if Length(pTexto) > 0 then
        Result := CRLF
     else
        Result := '';
end;

//-------------------------------------------------------------------------------------------------------------------
procedure AdicionaLinha(var S: string; const Linha: string; const Quebras: Integer = 1);
begin
     if Trim(S) <> '' then
        S := S + DupeString(#13#10, Quebras);
     S := S + Linha;
end;

//-------------------------------------------------------------------------------------------------------------------
function InverteMesAno(const PMesAno: string; const SemBarra: Boolean = False): string;
begin
     Result := FH.CopyPosMax(PMesAno, FH.SeparadorData) +
               FH.SeSenao(SemBarra, '', FH.SeparadorData) +
               FH.CopyPos(PMesAno, FH.SeparadorData);
end;


function InverteDiaMes(const pDiaMes_OU_MesDia: string): string;
begin
    if Length(pDiaMes_OU_MesDia) = 5 then
       Result := LeftStr(PDiaMes_OU_MesDia,2) + '/' + RightStr(PDiaMes_OU_MesDia,2)
    else
       Result := PDiaMes_OU_MesDia;
end;


//-------------------------------------------------------------------------------------------------------------------
function InverteAnoMes(const PAnoMes: string): string;
begin
  Result := FH.CopyPosMax(PAnoMes, FH.SeparadorData) + FH.SeparadorData +
            FH.CopyPos(PAnoMes, FH.SeparadorData);
end;

//-------------------------------------------------------------------------------------------------------------------
function IncMesAno(const PMesAno: string; const Incremento: Integer): string;
begin
    Result := PMesAno;
    if FH.MesAnoValido(Result) then
       Result := FH.GetMesAno(DateToStr(IncMonth(RecodeDay(StrToDate('01/' + Result), 1), Incremento)));
end;

//-------------------------------------------------------------------------------------------------------------------
function IncAnoMes(const PAnoMes: string; const Incremento: Integer): string;
begin
    Result := PAnoMes;
    if FH.AnoMesValido(Result) then
        Result := FH.InverteMesAno(FH.GetMesAno(DateToStr(IncMonth(StrToDate('01/' + FH.InverteAnoMes(Result)), Incremento))));
end;

//-------------------------------------------------------------------------------------------------------------------
function MesAnoValido(const pValor: string): Boolean;
const
  ARRAY_MESES : array[1..12] of string = ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12');
begin
  Result := false;

  if FH.StrInvalida(pValor)
  or FH.NaoTemInteiro(pValor)
  or (not AnsiContainsText(pValor, FH.SeparadorData))
  or (Length(pValor) <> 7)
  or (not AnsiMatchText(LeftStr(pValor, 2), ARRAY_MESES))
  or FH.IntInvalido(copy(pValor, 1, 1))
  or FH.IntInvalido(copy(pValor, 2, 1))
  or FH.IntInvalido(copy(pValor, 4, 1))
  or FH.IntInvalido(copy(pValor, 5, 1))
  or FH.IntInvalido(copy(pValor, 6, 1))
  or FH.IntInvalido(copy(pValor, 7, 1)) then
    exit;

  Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
function AnoMesValido(const pValor: string): Boolean;
const
  ARRAY_MESES : array[1..12] of string = ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12');
begin
  Result := false;

  if FH.StrInvalida(pValor)
  or FH.NaoTemInteiro(pValor)
  or (not AnsiContainsText(pValor, FH.SeparadorData))
  or (Length(pValor) <> 7)
  or (not AnsiMatchText(Copy(pValor, 6, 2), ARRAY_MESES))
  or FH.IntInvalido(copy(pValor, 1, 1))
  or FH.IntInvalido(copy(pValor, 2, 1))
  or FH.IntInvalido(copy(pValor, 3, 1))
  or FH.IntInvalido(copy(pValor, 4, 1))
  or FH.IntInvalido(copy(pValor, 6, 1))
  or FH.IntInvalido(copy(pValor, 7, 1)) then
    exit;

  Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
function TrataMesAno(PMaskEdit: TMaskEdit): Boolean;
var
     temp, vAno: string;
begin
     Result := true;
     temp := PMaskEdit.Text;
     if FH.NaoTemInteiro(temp) then
        exit;
     if not AnsiMatchText(FH.CopyPos(temp, '/'), ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12',
                                                       '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
     begin
          Result := false;
          FH.MsgFocalize(PMaskEdit, 'Referência inválida.');
          exit;
     end;
     if AnsiMatchText(FH.CopyPos(temp, '/'), ['1', '2', '3', '4', '5', '6', '7', '8', '9']) then
     begin
          temp := '0' + FH.CopyPos(temp, '/') + '/' + FH.CopyPosMax(temp, '/', False);
     end;
     vAno := Copy(temp, 4, 4);
     if Pos(FH.UM_ESPACO, vAno) = 0 then
        exit;
     Result := false;
     vAno := FH.LimpaEspacos(vAno);
     if vAno = '' then
     begin
         vAno := IntToStr(CurrentYear);
     end;
     if FH.MsgFocalizeSe(FH.StrInvalida(vAno), PMaskEdit, 'Referência inválida.') then
        exit;
     if Length(vAno) < 4 then
     begin
          if StrToInt(vAno) < 50 then
             vAno := '2'  + FH.StrZero(vAno, 3)
          else
             vAno := '19' + FH.StrZero(vAno, 2);
     end;
     temp := FH.CopyPos(temp, '/') + '/' + vAno;
     PMaskEdit.Text := temp;
     Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
function TrataAnoMes(PMaskEdit: TMaskEdit): Boolean;
var
     temp, vAno: string;
begin
     Result := true;
     temp := PMaskEdit.Text;
     if FH.NaoTemInteiro(temp) then
        exit;

     vAno := Copy(temp, 1, 4);
     if Pos(FH.UM_ESPACO, vAno) <> 0 then
     begin
          Result := false;
          vAno := FH.LimpaEspacos(vAno);
          if vAno = '' then
          begin
               vAno := IntToStr(CurrentYear);
          end;
          if FH.MsgFocalizeSe(FH.StrInvalida(vAno), PMaskEdit, 'Referência inválida.') then
             exit;
          if Length(vAno) < 4 then
          begin
               if StrToInt(vAno) < 50 then
                  vAno := '2'  + FH.StrZero(vAno, 3)
               else
                  vAno := '19' + FH.StrZero(vAno, 2);
          end;
     end;

     if AnsiMatchText(FH.CopyPosMax(temp, '/', False), ['1', '2', '3', '4', '5', '6', '7', '8', '9']) then
     begin
          temp := FH.CopyPos(temp, '/') + '/0' + FH.CopyPosMax(temp, '/', False);
     end;
     if not AnsiMatchText(FH.CopyPosMax(temp, '/', False), ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12',
                                                      '1', '2', '3', '4', '5', '6', '7', '8', '9']) then
     begin
          Result := false;
          FH.MsgFocalize(PMaskEdit, 'Referência inválida.');
          exit;
     end;
     temp := vAno  + '/' + FH.CopyPosMax(temp, '/', False);
     PMaskEdit.Text := temp;
     Result := true;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ImportaCDS(CDS: TClientDataSet; const pNomeArq: string);
var
     SL, W : TStrings;
     iTam, i  : integer;
     s, sLinha, sTipo, sTam, sValor  : string;
     vTipo  : TFieldType;
begin
     SL := TStringList.Create;
     W := TStringList.Create;
     try
        SL.LoadFromFile(pNomeArq);
        s := SL.Text;
        CDS.Close;
        CDS.FieldDefs.Clear;
        s := FH.CopyPos(FH.CopyPosMax(s, '>DEF>'), '>DEF*>');
        W.Text := s;
        for i := 0 to W.Count - 1 do
        begin
             s     := FH.CopyPosMax(FH.CopyPos   (W[i], ':'), '=');
             sTipo := FH.CopyPos   (FH.CopyPosMax(W[i], ':'), ':');
             sTam  := FH.CopyPosMax(FH.CopyPosMax(W[i], ':'), ':');

             vTipo := TFieldType(GetEnumValue(TypeInfo(TFieldType), sTipo));
             iTam  := 0;
             if (vTipo = ftString) or (vTipo = ftMemo) then
                iTam := StrToInt(sTam);

             CDS.FieldDefs.Add(s, vTipo, iTam);
        end;
        CDS.CreateDataSet;
        CDS.DisableControls;
        s := SL.Text;
        s := FH.CopyPosMax(s, '>DEF*>');
        while Pos('>LN*>', s) > 0 do
        begin
             sLinha := FH.CopyPos(FH.CopyPosMax(s, '>LN>'), '>LN*>');
             CDS.Append;
             for i := 0 to CDS.FieldDefs.Count - 1 do
             begin
                  sValor := FH.CopyPosMax(sLinha, '>[' + IntToStr(i) + ']>');
                  sValor := FH.CopyPos(sValor, '>[' + IntToStr(i) + ']*>');
                  if sValor <> '(null)' then
                     CDS.Fields[i].AsString := sValor;
             end;
             CDS.Post;
             s := FH.CopyPosMax(s, '>LN*>');
        end;
        CDS.First;
        CDS.EnableControls;
     finally
        FreeAndNil(SL);
        FreeAndNil(W);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ExportaDataSet(DS: TDataSet; const pNomeArq: string): string;
var
     SL : TStrings;
     v  : Variant;
     ps ,
     i  : integer;
     s  : string;
begin
     Result := '';
     SL := TStringList.Create;
     try
        SL.Add('>DEF>');
        for i := 0 to DS.FieldCount - 1 do
        begin
             SL.add(IntToStr(i) + '=' + DS.Fields[i].FieldName + ':' +
                    GetEnumName(TypeInfo(TFieldType), Integer(DS.Fields[i].DataType)) + ':' +
                    IntToStr(DS.Fields[i].DataSize) );
        end;
        SL.Add('>DEF*>');
        ps := DS.RecNo;
        DS.DisableControls;
        DS.First;
        while not DS.Eof do
        begin
             s := '';
             for i := 0 to DS.FieldCount - 1 do
             begin
                  v := DS.FieldByName(DS.Fields[i].FieldName).Value;
                  if VarIsNull(v) then
                     s := s + '>[' + IntToStr(i) + ']>(null)' + '>[' + IntToStr(i) + ']*>'
                  else
                     s := s + '>[' + IntToStr(i) + ']>' + DS.FieldByName(DS.Fields[i].FieldName).AsString + '>[' + IntToStr(i) + ']*>';
             end;
             SL.Add('>LN>' + s + '>LN*>');
             DS.Next;
        end;
        DS.RecNo := ps;
        DS.EnableControls;
        Result := SL.Text;
        SL.SaveToFile(pNomeArq);
     finally
        FreeAndNil(SL);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ControlaTeclaMesAno(var Key: Char; PMaskEdit: TMaskEdit);
begin
  if (Key <> '+') and (Key <> '-') and (Key <> 't') and (Key <> 'T') then
    exit;
  with PMaskEdit do
  begin
    if (FH.NaoTemInteiro(text)) or (not FH.MesAnoValido(text)) then
      text := FH.GetMesAno(Now);
    case Key of
      '+': Text := FH.GetMesAno(IncMonth(FH.MontaDataMesAno(Text)));
      '-': Text := FH.GetMesAno(IncMonth(FH.MontaDataMesAno(Text), -1));
      't', 'T':
           Text := FH.GetMesAno(Now);
    end;
    Key := #0;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ControlaTeclaAnoMes(var Key: Char; PMaskEdit: TMaskEdit);
begin
  if (Key <> '+') and (Key <> '-') and (Key <> 't') and (Key <> 'T') then
    exit;
  with PMaskEdit do
  begin
    if (FH.NaoTemInteiro(text)) or (not FH.AnoMesValido(text)) then
      text := FH.GetAnoMes(Now);
    case Key of
      '+': Text := FH.GetAnoMes(IncMonth(FH.MontaDataAnoMesInt(Text)));
      '-': Text := FH.GetAnoMes(IncMonth(FH.MontaDataAnoMesInt(Text), -1));
      't', 'T':
           Text := FH.GetAnoMes(Now);
    end;
    Key := #0;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function SeStrVazia(const PStr, PDefault: string): string;
begin
     Result := PStr;
     if FH.StrInvalida(Result) then
        Result := PDefault;
end;

//-------------------------------------------------------------------------------------------------------------------
function CalcPorcentagem(const X, Y: double): double;
begin
  Result := (Y * X) / 100;
end;

//-------------------------------------------------------------------------------------------------------------------
function CalcPorcentagemTotal(const X, Y: double): double;
begin
  Result := 100 * (X / Y);
end;

//-------------------------------------------------------------------------------------------------------------------
function CalcPorcentagemDelta(const X, Y: double): double;
begin
  Result := 100 * ((X - Y) / Y);
end;

//-------------------------------------------------------------------------------------------------------------------
function MaiorQue(const PValor1, PValor2: Extended; const PDelta: Extended = 0): Extended;
begin
  if PValor1 > PDelta then
    Result := PValor1
  else
    Result := PValor2;
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtDataDDMMAA(const PData: string): string;
begin
  Result := PData;
  if FH.DataOk(PData) then
    Result := FormatDateTime('dd/mm/yy', StrToDate(PData));
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtDataDDMMAAHHMM(const PDataHora: string): string;
begin
  Result := PDataHora;
  if FH.DataHoraOk(PDataHora) then
    Result := FormatDateTime('dd/mm/yy hh:mm', StrToDateTime(PDataHora));
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaMesAnoExtenso(const DataOuMesAno: string; const AnoComDoisDigitos: Boolean = false): string;
begin
  Result := DataOuMesAno;
  if FH.MesAnoValido(Result) then
    Result := '01/' + Result
  else
  if not FH.DataOk(Result) then
    exit;
  Result := FormatDateTime('mmmm/' + IfThen(AnoComDoisDigitos, 'yy', 'yyyy'),
                           StrToDate(Result));
  Result := FH.SetaUpper(Result, 1);
end;

//-------------------------------------------------------------------------------------------------------------------
function ListaParaStr(ALista: TStrings): string;
var
     ii: integer;
begin
     Result := '';
     for ii := 0 to ALista.Count - 1 do
         Result := Result + ifthen(Result > '', ', ') + ALista[ii];
end;

//-------------------------------------------------------------------------------------------------------------------
procedure InsereNaLista(Lista: TStrings; const Linhas: string; const TextoPlano: Boolean = True; const RemoverAspas: Boolean = false);
var
    i: integer;
    L: TStrings;
    s: string;
begin
    if Linhas = '' then
       Exit;
    L := TStringList.Create;
    try
       if TextoPlano then
          L.Text := Linhas
       else
          FH.StrParaLista( Linhas, L );
       for i := 0 to L.Count-1 do
       begin
            s := L[i];
            if RemoverAspas then
               s := FH.LimpaAspas( s );
            Lista.Add( s );
       end;
    finally
       FreeAndNil( L );
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure FormaLista(var V: string; const S: string; const Espacado: Boolean = True; const ComQuebras: Boolean = False; const PontoEVirgula: Boolean = False);
var
     p: string;
begin
     if PontoEVirgula then
        p := ';'
     else
        p := ',';
     if ComQuebras then
        V := V + IfThen(V > '', sLineBreak) + S
     else
        V := V + IfThen(V > '', IfThen(Espacado, p + ' ', p)) + S;
end;

//-------------------------------------------------------------------------------------------------------------------
function FormaListaStr(const strResultante, strAdicionar: string; const Espacado: Boolean = True): string;
begin
     Result := strResultante + FH.SeSenao(strResultante <> '', FH.SeSenao(Espacado, ', ', ','), '') + strAdicionar;
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtMinutos(const Z: int64; const MostraSegundos: Boolean = False): string;
var
     H, M: integer;
     sHoras: string;
begin
     H := Round(Int(Z / 60));
     M := Round(Int(Z - (H * 60)));
     if Length(IntToStr(H)) < 2 then
        sHoras := FH.StrZero(H, 2)
     else
        sHoras := IntToStr(H);
     if MostraSegundos then
        Result := Format('%s:%s:%s', [sHoras, FH.StrZero(M, 2), '00'])
     else
        Result := Format('%s:%s', [sHoras, FH.StrZero(M, 2)]);
end;

//-------------------------------------------------------------------------------------------------------------------
function FmtMilesimos(const Z: int64; const MostraMilesimos: Boolean = True; const MostraSegundos: Boolean = True): string;
var
     H, M, S, L: integer;
     T: double;
     sHoras: string;
begin
     T := Z / 1000;
     H := Round(Int(T / 3600));
     M := Round(Int((T - H * 3600) / 60));
     if Length(IntToStr(H)) < 2 then
        sHoras := FH.StrZero(H, 2)
     else
        sHoras := IntToStr(H);
     if MostraMilesimos then
     begin
          S := Round(int(T - H * 3600 - M * 60));
          L := Z - ((S * 1000) + (M * 60000) + (H * 3600000));
          Result := Format('%s:%s:%s:%s', [sHoras, FH.StrZero(M, 2),
                                           FH.StrZero(S, 2), FH.StrZero(L, 4)]);
     end
     else
     begin
          if MostraSegundos then
          begin
               S := Round(T - H * 3600 - M * 60);
               Result := Format('%s:%s:%s', [sHoras, FH.StrZero(M, 2), FH.StrZero(S, 2)]);
          end
          else
          begin
               Result := Format('%s:%s', [sHoras, FH.StrZero(M, 2)]);
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaHoraDelta(const BaseZ: int64): string;
begin
  Result := FH.FmtMilesimos(GetTickCount - BaseZ, false);
end;

//-------------------------------------------------------------------------------------------------------------------
function Locate(DS: TDataSet; const PCampos: string;
                              const PValores: array of string;
                              const PInsensitive: Boolean;
                              const PDisableControls: Boolean = false;
                              const PBookmark: Boolean = True): Boolean;
var
    I: integer;
    ok: Boolean;
    bkmr: TBookmark;
    vCampo, vLista, tmp : string;
begin
    Result := false;
    if DS.IsEmpty then
      exit;
    try
      if PBookmark then
         bkmr := DS.GetBookmark;
      vLista := StringReplace(PCampos, ';', ',', [rfReplaceAll]) + ',';
      if PDisableControls then
         DS.DisableControls;
      DS.First;
      while not DS.Eof do
      begin
          I := 0;
          tmp := vLista;
          while AnsiContainsStr(tmp, ',') do
          begin
              vCampo := FH.CopyPos(tmp, ',');
              if I <= high(PValores) then
              begin
                  if PInsensitive then
                    ok := AnsiSameText(PValores[I], DS.FieldByName(vCampo).AsString)
                  else
                    ok := AnsiSameStr(PValores[I], DS.FieldByName(vCampo).AsString);
              end
              else
                  ok := false;
              if not ok then
                 break;
              Inc(I);
              tmp := FH.CopyPosMax(tmp, ',');
          end;
          Result := ok;
          if Result then
            exit;
          DS.Next;
      end;
    finally
      if PBookmark then
      begin
           if not Result then
              DS.GotoBookmark(bkmr);
           DS.FreeBookmark(bkmr);
      end;
      if PDisableControls then
         DS.EnableControls;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function IfThenColor(const PCondic: Boolean; const PTrue, PFalse: TColor): TColor;
begin
  if PCondic then
    Result := PTrue
  else
    Result := PFalse;
end;

//-------------------------------------------------------------------------------------------------------------------
function StrParecida(const S1, S2: string): Boolean;
begin
  Result := AnsiSameText(FH.LimpaChrEspecial(S1), FH.LimpaChrEspecial(S2));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetValIndex(const Index: integer; const Valores: array of string; const Quoted: Boolean = false): string;
begin
  Result := '';
  if (Index > high(Valores)) or (Index < low(Valores)) then
    exit;
  Result := Valores[Index];
  if Quoted then Result := QuotedStr(Result);
end;

//-------------------------------------------------------------------------------------------------------------------
function CaseOf(const Valor: string; const IDs, Results: array of string): string;
var
  ii: integer;
begin
  Result := Valor;
  ii     := AnsiIndexText(Valor, IDs);
  if ii < 0 then
    exit;
  if (ii > high(Results)) or (ii < low(Results)) then
    exit;
  Result := Results[ii];
end;

//-------------------------------------------------------------------------------------------------------------------
function VerificaCargaArquivo(const PArq: string) : Boolean ;
var
    MS : TMemoryStream;
begin
    MS := TMemoryStream.Create;
    try
        try
           MS.LoadFromFile(PArq);
           Result := True;
        except
           Result := False;
        end;
    finally
        MS.Destroy;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaArqTab(const PArq: string; DS: TDataSet; const pCampo: string);
var
    MS : TMemoryStream;
begin
    MS := TMemoryStream.Create;
    try
        MS.LoadFromFile(PArq);
        (DS.FieldByName(pCampo) as TBlobField).LoadFromStream(MS);
    finally
        MS.Destroy;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function GeraArqTab(DS: TDataSet; const pCampo, PDestino: string; const AbreArq: Boolean; const GeraNovoSeExiste: Boolean = True): string;
var
    ST : TStream;
    MS : TMemoryStream;
    tmpDest, vNome, vExtn : string;
begin
    Result := '';
    MS := TMemoryStream.Create;
    try
        ST := DS.CreateBlobStream(DS.FieldByName(pCampo), bmRead);
        MS.LoadFromStream(ST);
        tmpDest := PDestino;
        if GeraNovoSeExiste and FileExists(tmpDest) then
        begin
             vNome := ExtractFileName(tmpDest);
             if ExtractFileExt(vNome) <> '' then
             begin
                  vNome := ReverseString(vNome);
                  vExtn := FH.CopyPos(vNome, '.');
                  vNome := FH.CopyPosMax(vNome, '.');
                  vNome := ReverseString(vNome);
                  vNome := vNome + '_' + FormatDateTime('ddmmyyyy.hhmmsszzz', Now);
                  vNome := vNome + '.' + ReverseString(vExtn);
             end
             else
             begin
                  vNome := vNome + '_' + FormatDateTime('ddmmyyyy.hhmmsszzz', Now);
             end;
             tmpDest := FH.AdicionaDelimitador(ExtractFilePath(tmpDest)) + vNome;
        end;
        MS.SaveToFile(tmpDest);
        Result := tmpDest;
        if AbreArq then
           FH.ExecutaArquivo(tmpDest);
    finally
        MS.Destroy;
        ST.Free;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaImagemTab(PC: TPicture; DS: TDataSet; const pCampo: string);
var
    MS : TMemoryStream;
begin
    MS := TMemoryStream.Create;
    try
       if PC.Width > 0 then
          PC.Graphic.SaveToStream(MS);
       (DS.FieldByName(pCampo) as TBlobField).LoadFromStream(MS);
    finally
       MS.Destroy;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function LeImagemTab(PC: TPicture; DS: TDataSet; const pCampo, PExtensao: string): Int64 ;
var
    ST  : TStream;
    JPG : TJPEGImage;
    BTM : TBitmap;
    PNG : TPngImage;
begin
    Result := 0;
    if not DS.Active then
       Exit;
    if DS.IsEmpty then
       Exit;
    if DS.FindField(pCampo) = nil then
       raise Exception.CreateFmt('Campo %s não localizado no dataset %s.', [pCampo, DS.Name]);
    try
        JPG := nil;
        BTM := nil;
        PNG := nil;
        ST  := DS.CreateBlobStream(DS.FieldByName(pCampo), bmRead);

        Result := ST.Size;

        if ST.Size > 0 then
        begin
            if AnsiContainsText(PExtensao, 'JPG') then
            begin
                try
                    JPG := TJPEGImage.Create;
                    JPG.LoadFromStream(ST);
                    PC.Assign(JPG)
                except
                    //
                end;
            end
            else
            if AnsiContainsText(PExtensao, 'PNG') then
            begin
                try
                    PNG := TPngImage.Create;
                    ST.Position := 0;
                    PNG.LoadFromStream(ST);
                    PC.Assign(Png);
                except
                    //
                end;
            end
            else
            if AnsiContainsText(PExtensao, '*') then
            begin
                try
                    JPG := TJPEGImage.Create;
                    JPG.LoadFromStream(ST);
                    PC.Assign(JPG)
                except
                    try
                        BTM := TBitmap.Create;
                        BTM.LoadFromStream(ST);
                        PC.Bitmap.Assign(BTM);
                    except
                        //
                    end;
                end;
            end
            else
            begin
                try
                    BTM := TBitmap.Create;
                    BTM.LoadFromStream(ST);
                    PC.Bitmap.Assign(BTM);
                except
                    //
                end;
            end;
        end
        else
            PC.Assign(nil);
    finally
        JPG.Free;
        BTM.Free;
        PNG.Free;
        ST.Free;

    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerOwner(FR: TForm; const POwner: string): Boolean;
begin
     Result := False;
     if FH.RetForm(POwner) <> nil then
        if FR.Owner is TForm then
           if SameText((FR.Owner as TForm).Name, FH.RetForm(POwner).Name) then
              Result := True;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerCampoNum(FL: TField): Boolean;
begin
     Result := (FL.DataType = ftBCD) or (FL.DataType = ftFloat);
end;

function VerCampoNum(FT: TFieldType): Boolean;
begin
     Result := (FT = ftBCD) or (FT = ftFloat);
end;

//-------------------------------------------------------------------------------------------------------------------
function ProperCase(PStr: string): string;
var
     L, i: integer;
begin
     Result  := '';
     L    := Length(PStr);
     PStr := AnsiUpperCase(MidStr(PStr, 1, 1)) + AnsiLowerCase(MidStr(PStr, 2, L));

     for i := 0 to L do
     begin
          if (MidStr(PStr, i, 1) = FH.UM_ESPACO)
          or (MidStr(PStr, i, 1) = '-')
          or (MidStr(PStr, i, 1) = #39)
          or (MidStr(PStr, i, 1) = '(')
          or (MidStr(PStr, i, 1) = '/') then
            PStr := MidStr(PStr, 0, i) +
                    AnsiUpperCase(MidStr(PStr, i + 1, 1)) +
                    AnsiLowerCase(MidStr(PStr, i + 2, L));
     end;

     Result := stringReplace(PStr  , ' De ', ' de ', [rfReplaceAll]);
     Result := stringReplace(Result, ' Do ', ' do ', [rfReplaceAll]);
     Result := stringReplace(Result, ' Da ', ' da ', [rfReplaceAll]);
     Result := stringReplace(Result, ' E ' , ' e ' , [rfReplaceAll]);
     Result := stringReplace(Result, ' A ' , ' a ' , [rfReplaceAll]);
     Result := stringReplace(Result, ' Ii' , ' II' , [rfReplaceAll]);
     Result := stringReplace(Result, ' Iii' , ' III' , [rfReplaceAll]);

     Result := stringReplace(Result, ' Iv ' , ' IV ' , [rfReplaceAll]);
end;

//-------------------------------------------------------------------------------------------------------------------
function SentenceCase(const pStr: string; const pTrim: Boolean = True): string;
begin
     if pTrim then
        Result := FH.SetaUpper(AnsiLowerCase(Trim(pStr)), 1)
     else
        Result := FH.SetaUpper(AnsiLowerCase(TrimLeft(pStr)), 1);
end;

//-------------------------------------------------------------------------------------------------------------------
function Reticencias(PStr: string; const PTam: Integer): string;
begin
     Result := PStr;
     if (Length(Result) <= PTam) or (Length(Result) = 0) then
        Exit;
     Result := Copy(Result, 1, PTam) + '...';
end;

//-------------------------------------------------------------------------------------------------------------------
function StrToWord(const Value: String): Word;
begin
     Result := Word(pointer(@Value[1])^);
end;

//-------------------------------------------------------------------------------------------------------------------
function WordToStr(const Value: Word): string;
begin
     SetLength(Result, SizeOf(Value));
     Move(Value, Result[1], SizeOf(Value));
end;

//-------------------------------------------------------------------------------------------------------------------
function StrParaVar(const PStr: string): Variant;
begin
     Result := null;
     if PStr > '' then
        Result := PStr;
end;

//-------------------------------------------------------------------------------------------------------------------
function ContaPalavra(const PStr: string): Integer;
var
     PChr  : char;
     IsWord : Boolean;
     i      : integer;
     sTemp  : string;
begin
     Result := 0;
     IsWord := False;
     sTemp  := FH.LimpaChrEspecial(PStr);
     if Length(sTemp) < 1 then
        Exit;
     for i := 0 to Length(sTemp) do
     begin
          PChr := sTemp[i];
          if PChr in ['a'..'z', 'A'..'Z', '0'..'9', '''', '-'] then
          begin
               if not IsWord then
                 Inc(Result);
               IsWord := True;
          end
          else
          if PChr = '\' then
             IsWord := True
          else
             IsWord := False
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function SetaNomeValidoArquivo(const pNomeArq: string): string;
begin
     Result := trim(pNomeArq);
     Result := StringReplace(Result, '\', '-' , [rfReplaceAll]);
     Result := StringReplace(Result, '/', '-' , [rfReplaceAll]);
     Result := StringReplace(Result, ':', '-' , [rfReplaceAll]);
     Result := StringReplace(Result, '*', '-' , [rfReplaceAll]);
     Result := StringReplace(Result, '?', '.' , [rfReplaceAll]);
     Result := StringReplace(Result, '"', '''', [rfReplaceAll]);
     Result := StringReplace(Result, '>', ')' , [rfReplaceAll]);
     Result := StringReplace(Result, '<', '(' , [rfReplaceAll]);
     Result := StringReplace(Result, '|', '-' , [rfReplaceAll]);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GravaLista(var L: TStrings; const Arquivo: string);
var
     fs: TFileStream;
begin
     fs := TFileStream.Create(Arquivo, fmCreate);
     try
       L.SaveToStream(fs, L.Encoding);
       fs.Size := fs.Size - Length(system.sLineBreak);
     finally
            fs.Free;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function CapturaTela(const PHandleJanela: HWND): TBitmap;
var
     dc : HDC;
     cv : TCanvas;
     w, h : Integer;
     hWin : Cardinal;
     r : TRect;
begin
     Result := TBitmap.Create;
     if PHandleJanela <> 0 then
     begin
          hWin := PHandleJanela;
          try
             dc := GetWindowDC(hWin) ;
             GetWindowRect(hWin, r) ;
             w := r.Right - r.Left;
             h := r.Bottom - r.Top;

             Result.Width  := w;
             Result.Height := h;
             BitBlt(result.Canvas.Handle, 0, 0, Result.Width, Result.Height, dc, 0, 0, SRCCOPY) ;
          finally
                 ReleaseDC(hWin, dc) ;
          end;
     end
     else
     begin
          Result.Width  := Screen.Width;
          Result.Height := Screen.Height;
          try
            dc := GetDC(0);
            cv := TCanvas.Create;
            cv.Handle := dc;

            Result.Canvas.CopyRect(Rect(0, 0, Screen.Width, Screen.Height), cv,
                                   Rect(0, 0, Screen.Width, Screen.Height));
          finally
                 cv.Free;
                 ReleaseDC(0, DC);
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function CapturaTelaJPG(const PHandleJanela: HWND; const AArquivoSaida: string): TJpegImage;
var
     objBmp : TBitmap;
     objJpg : TJpegImage;
begin
     Result := nil;
     try
        objBmp := FH.CapturaTela(PHandleJanela);
        objJpg := TJpegImage.Create;
        try
           objJpg.Assign(objBmp);
           objJpg.CompressionQuality := 50;
           if AArquivoSaida > '' then
              objJpg.SaveToFile(AArquivoSaida);
           Result := objJpg;
        finally
           FreeAndNil(objJpg);
        end;
     finally
        FreeAndNil(objBmp);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VarParaFloat(const V: Variant): Extended;
begin
     Result := 0;
     if not VarIsNull(V) then
        if VarIsNumeric(V) then
           Result := FindVarData(V)^.VDouble;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetNomeComputador: string;
var
  buf   : array[0..255] of char;
  nSize : Cardinal;
begin
  nSize := sizeof(buf);
  if Windows.GetComputerName(buf, nSize) then
    Result := buf
  else
    Result := buf;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PreparaPChar(var P: PChar; const Org: string; const TamanhoMaximo, TamAloca: Cardinal);
begin
  P := StrAlloc(TamAloca);
  StrPLCopy(P, Org, TamanhoMaximo);
  P[TamanhoMaximo] := #0;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure PreparaPAnsiChar(var P: PAnsiChar; const Org: string; const TamanhoMaximo, TamAloca: Cardinal);
begin
  P := AnsiStrAlloc(TamAloca);
  StrPLCopy(P, Org, TamanhoMaximo);
  P[TamanhoMaximo] := #0;
end;

//-------------------------------------------------------------------------------------------------------------------
function TotalDiasUteis(PData: string; const ConsideraSabados: Boolean): Integer;
var
  dtAux : TDate;
  dtUlt : TDate;
  cc    : Integer;
begin
  Result := 0;
  dtAux  := StrToDate(PData);
  dtUlt  := FH.UltimoDiaMes(dtAux);
  while dtAux <= dtUlt do
  begin
    cc := DayOfTheWeek(dtAux);
    if (cc < DIASEM_SABADO) or ((cc = DIASEM_SABADO) and ConsideraSabados) then
      Inc(Result);
    dtAux := IncDay(dtAux, 1);
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure QuickSort(var A: array of Integer);

     procedure processaOrdena(var pArray: array of Integer; pLow, pHigh: Integer);
     var
          vLow, vHigh, vMid, t: Integer;
     begin
          vLow := pLow;
          vHigh := pHigh;
          vMid := pArray[(vLow + vHigh) div 2];
          repeat
                while pArray[vLow] < vMid do Inc(vLow);
                while pArray[vHigh] > vMid do Dec(vHigh);
                if vLow <= vHigh then
                begin
                     t := pArray[vLow];
                     pArray[vLow] := pArray[vHigh];
                     pArray[vHigh] := t;
                     Inc(vLow);
                     Dec(vHigh);
                end;
          until vLow > vHigh;
          if vHigh > pLow then processaOrdena(pArray, pLow, vHigh);
          if vLow < pHigh then processaOrdena(pArray, vLow, pHigh);
     end;

begin
     processaOrdena(A, Low(A), High(A));
end;

//-------------------------------------------------------------------------------------------------------------------
function TickCountStr: string;
begin
     Result := IntToStr(GetTickCount);
end;

//-------------------------------------------------------------------------------------------------------------------
function GetUID(const pTamanho: Integer = -1): string;
var
     u: TGuid;
     r: HResult;
begin
     Result := '';
     r := CreateGuid(u);
     if r = S_OK then
     begin
        Result := AnsiLowerCase(FH.LimpaString(GuidToString(u), ['{', '}', '-']));
        if pTamanho > 0 then
           Result := LeftStr(Result, pTamanho);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RandomString(const TamanhoMaximo: Integer; const Completar: Boolean): string;
const
     m = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz0123456789';
var
     i, k : Integer;
begin
     Result := '';
     if Completar then
        k := TamanhoMaximo
     else
        k := RandomRange(1, TamanhoMaximo);
     while Length(Result) < k do
     begin
          i := RandomRange(1, 72);
          Result := Result + m[i];
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function EmailOK(const AEmail: string; AMetodoRFC: Boolean = False): Boolean;
var
     emails, tmp : string;

     function ValidarSimples(const Endereco: string): Boolean;
     var
          email, valido, validoA, s: String;
          i                         : Integer;
     begin
          Result  := True;
          if Endereco = '' then
             Exit;

          valido  := '01234567890@-_.abcdefghijklmnopqrstuvwxyz';
          validoA := '.abcdefghijklmnopqrstuvwxyz';
          email   := AnsiLowerCase(Endereco);
          for i  := 1 to Length(email) do
          begin
            s      := email[i];
            Result := FH.PosStr(s, valido) > 0;
            if not Result then
               Exit;
          end;

          Result  := False;

          if (not (email[1] in ['0'..'9', 'a'..'z']))
          or (not (email[Length(email)] in ['a'..'z'])) then // deve iniciar/terminiar com os caracteres validos
              Exit;

          s := trim(FH.CopyPos(Endereco, '@'));
          if Length(s) < 2 then // deve ter no minimo 2 caracteres antes da '@'
             Exit;

          s := FH.CopyPosMax(Endereco, '@');
          s := trim(FH.CopyPos(s, '.'));
          if Length(s) < 2 then // deve ter no minimo 2 caracteres enntre a '@' e o '.'
             Exit;

          //  central@pro.via-rs.com.br
          i    := 3;
          email := FH.CopyPosMax(Endereco, '@');
          email := FH.CopyPosMax(email, '.');

          while FH.ContaStr(email, '.') > 1 do
                email := FH.CopyPosMax(email, '.');

          if Pos('.',email) > 0 then
             i := 6;

          if Length(email) <> i then // deve acabar com XXX ou XXX.XX
             Exit;

          for i := 1 to Length(email) do
          begin
            s      := email[i];
            Result := FH.PosStr(s, validoA) > 0;
            if not Result then
               Exit;
          end;

          Result := True;
     end;

     function ValidarRFC(Endereco: string): boolean;
     const
          atom_chars = [#33..#255] - ['(', ')', '<', '>', '@', ',', ';', ':',
                                      '\', '/', '"', '.', '[', ']', #127];
          quoted_string_chars = [#0..#255] - ['"', #13, '\'];
          letters = ['A'..'Z', 'a'..'z'];
          letters_digits = ['0'..'9', 'A'..'Z', 'a'..'z'];
          subdomain_chars = ['-', '0'..'9', 'A'..'Z', 'a'..'z'];
     type
          States = (STATE_BEGIN, STATE_ATOM, STATE_QTEXT, STATE_QCHAR,
                    STATE_QUOTE, STATE_LOCAL_PERIOD, STATE_EXPECTING_SUBDOMAIN,
                    STATE_SUBDOMAIN, STATE_HYPHEN);
     var
          State: States;
          i, n, subdomains: integer;
          c: char;
     begin
          State := STATE_BEGIN;
          n := Length(Endereco);
          i := 1;
          subdomains := 1;
          while (i <= n) do
          begin
               c := Endereco[i];
               case State of
                  STATE_BEGIN:
                    if c in atom_chars then
                      State := STATE_ATOM
                    else
                    if c = '"' then
                      State := STATE_QTEXT
                    else
                      break;
                  STATE_ATOM:
                    if c = '@' then
                      State := STATE_EXPECTING_SUBDOMAIN
                    else
                    if c = '.' then
                      State := STATE_LOCAL_PERIOD
                    else
                    if not (c in atom_chars) then
                      break;
                  STATE_QTEXT:
                    if c = '\' then
                      State := STATE_QCHAR
                    else
                    if c = '"' then
                      State := STATE_QUOTE
                    else
                    if not (c in quoted_string_chars) then
                      break;
                  STATE_QCHAR:
                    State := STATE_QTEXT;
                  STATE_QUOTE:
                    if c = '@' then
                      State := STATE_EXPECTING_SUBDOMAIN
                    else
                    if c = '.' then
                      State := STATE_LOCAL_PERIOD
                    else
                      break;
                  STATE_LOCAL_PERIOD:
                    if c in atom_chars then
                      State := STATE_ATOM
                    else
                    if c = '"' then
                      State := STATE_QTEXT
                    else
                      break;
                  STATE_EXPECTING_SUBDOMAIN:
                    if c in letters_digits then
                      State := STATE_SUBDOMAIN
                    else
                      break;
                  STATE_SUBDOMAIN:
                    if c = '.' then begin
                      inc(subdomains);
                      State := STATE_EXPECTING_SUBDOMAIN
                    end
                    else
                    if c = '-' then
                      State := STATE_HYPHEN
                    else
                    if not (c in letters_digits) then
                      break;
                  STATE_HYPHEN:
                    if c in letters_digits then
                      State := STATE_SUBDOMAIN
                    else
                    if c <> '-' then
                      break;
               end;
               inc(i);
          end;
          if i <= n then
            Result := False
          else
            Result := (State = STATE_SUBDOMAIN) and (subdomains >= 2);
     end;

begin
     if AEmail = '' then
     begin
          Result := True;
          Exit;
     end;
     emails := AEmail;
     while emails > '' do
     begin
          tmp := FH.CopyPos(emails,';');
          if AMetodoRFC then
             Result := ValidarRFC(tmp)
          else
             Result := ValidarSimples(tmp);
          if Result then
             emails := FH.CopyPosMax(emails,';')
          else
             emails := '';
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function SimStr(const aStr: string): Boolean;
begin
     Result := SameText( aStr, 'S' ) ;
end;

//-------------------------------------------------------------------------------------------------------------------
function SimNaoExtenso(const aStr: string): string;
begin
     if SameText( aStr, 'S') then
        result := 'Sim'
     else
        result := 'Não';
end;

//-------------------------------------------------------------------------------------------------------------------
function SeSenao(const aValor: Boolean; const aTrue: Integer; const aFalse: Integer = 0): Integer; overload;
begin
     if aValor then
        Result := aTrue
     else
        Result := aFalse;
end;

//-------------------------------------------------------------------------------------------------------------------
function SeSenao(const aValor: Boolean; const aTrue: Extended; const aFalse: Extended = 0): Extended; overload;
begin
     if aValor then
        Result := aTrue
     else
        Result := aFalse;
end;

//-------------------------------------------------------------------------------------------------------------------
function SeSenao(const aValor: Boolean; const aTrue: Variant; const aFalse: Variant): Variant; overload;
begin
     if aValor then
        Result := aTrue
     else
        Result := aFalse;
end;

//-------------------------------------------------------------------------------------------------------------------
function SeSenao(const aValor: Boolean; const aTrue: string; const aFalse: string = ''): string;
begin
     if aValor then
        Result := aTrue
     else
        Result := aFalse;
end;

//-------------------------------------------------------------------------------------------------------------------
function SeSenao(const aValor: Boolean; const aTrue: Int64; const aFalse: Int64 = 0): Int64;
begin
     if aValor then
        Result := aTrue
     else
        Result := aFalse;
end;

//-------------------------------------------------------------------------------------------------------------------
function StrDiferentes(const aStr1, aStr2: string): Boolean;
begin
     Result := AnsiCompareText(aStr1, aStr2) <> 0;
end;

//-------------------------------------------------------------------------------------------------------------------
function GetXMLTag(const Tag, Texto: string): string;
var
     p : Integer;
     s, x : string;
begin
     Result := '';
     p      := FH.PosStr('<' + Tag + '>', Texto);
     if p > 0 then
     begin
          s := FH.CopyPosMax(Texto, '<' + Tag + '>');
          x := '';

          if  (FH.PosStr('<' + Tag + '>', s) > 0)
          and (FH.PosStr('<' + Tag + '>', s) < FH.PosStr('</' + Tag + '>', s)) then
          begin
               // Tags internas com mesmo nome
               x := s;
               while FH.Contem(x, '<' + Tag + '>') do
               begin
                    x := StringReplace(x, '<'+Tag+'>', '<$$'+Tag+'>', [rfIgnoreCase]);
                    x := StringReplace(x, '</'+Tag+'>', '</$$'+Tag+'>', [rfIgnoreCase]);
               end;
               s := x;
          end;

          p := FH.PosStr('</' + Tag + '>', s);
          if p > 0 then
          begin
               Result := FH.CopyPos(s, '</' + Tag + '>', false);
               if x > '' then
               begin
                    Result := StringReplace(Result, '<$$'+Tag+'>', '<'+Tag+'>', [rfIgnoreCase, rfReplaceAll]);
                    Result := StringReplace(Result, '</$$'+Tag+'>', '</'+Tag+'>', [rfIgnoreCase, rfReplaceAll]);
               end;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function GetXMLTagAtrib(const Tag, Campo, Texto: string): string;
var
     p : Integer;
     s : string;
begin
     Result := '';
     p      := FH.PosStr('<' + Tag + ' ', Texto);
     if p > 0 then
     begin
          s := FH.CopyPosMax(Texto, '<' + Tag + ' ');
          p := FH.PosStr('/>', s);
          if p > 0 then
          begin
               s := FH.CopyPos(s, '/>');
               if Campo > '' then
                  if FH.Contem(FH.LimpaEspacos(s), Campo + '="') then
                  begin
                       s := CopyPosMax(s, Campo);
                       s := CopyPosMax(s, '=');
                       s := CopyPosMax(s, '"');
                       s := CopyPos(s, '"');
                  end;
               Result := s;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function SetXMLTag(const Tag, Texto: string): string;
begin
     Result := '';
     if Tag > '' then
        Result := '<' + Tag + '>' + Texto + '</' + Tag + '> ';
end;

//-------------------------------------------------------------------------------------------------------------------
function SeTemConteudo(const Texto, TxIni, TxFin: string): string;
begin
     Result := Texto;
     if FH.StrOk(Result) then
        Result := TxIni + Result + TxFin;
end;

//-------------------------------------------------------------------------------------------------------------------
function CarregaSeExiste(var L: TStrings; const pArq: string): Boolean;
begin
     Result := FileExists(pArq);
     if Result then
        L.LoadFromFile(pArq);
end;

//-------------------------------------------------------------------------------------------------------------------
function DataSetParaString(DS: TDataSet; const pCampo: string; const Espacado: Boolean = True; const Invertido: Boolean = False): string;
begin
     Result := '';
     if Invertido then
     begin
          DS.Last;
          while not DS.bof do
          begin
               FH.FormaLista(Result, DS.FieldByName(pCampo).AsString, Espacado);
               DS.Prior;
          end;
     end
     else
     begin
          DS.first;
          while not DS.eof do
          begin
               FH.FormaLista(Result, DS.FieldByName(pCampo).AsString, Espacado);
               DS.next;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerSessaoRemota: Boolean;
const
     sm_RemoteSession = $1000; { from WinUser.h }
begin
     try
        Result := (GetSystemMetrics(sm_RemoteSession) <> 0);
     except
        Result := False;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function TruncVal(const V: Extended): Extended;
var
     s: string;
begin
     Result := V;
     if frac(V) > 0 then
     begin
          s := FH.FmtFix(V, 8);
          s := FH.CopyPos(s, FH.SeparadorDecimal)+FH.SeparadorDecimal+
               copy(FH.CopyPosMax(s, FH.SeparadorDecimal),1,2);
          Result := StrToFloat(s);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function AjustaChrEspecial(const Texto: string): string;
begin
     Result := Texto;
     Result := stringReplace(Result, 'Ã€', 'À', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã', 'Á', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã‚', 'Â', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ãƒ', 'Ã', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã„', 'Ä', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã…', 'Å', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã‡', 'Ç', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã‰', 'É', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ãˆ', 'È', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã‰', 'É', [rfReplaceAll]);
     Result := stringReplace(Result, 'ÃŠ', 'Ê', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã‹', 'Ë', [rfReplaceAll]);
     Result := stringReplace(Result, 'ÃŒ', 'Ì', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã ', 'Í', [rfReplaceAll]);
     Result := stringReplace(Result, 'ÃŽ', 'Î', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã ', 'Ï', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã ', 'Ð', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã‘', 'Ñ', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã’', 'Ò', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã“', 'Ó', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã”', 'Ô', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã•', 'Õ', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã–', 'Ö', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã—', '×', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã˜', 'Ø', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã™', 'Ù', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ãš', 'Ú', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã›', 'Û', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ãœ', 'Ü', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã ', 'Ý', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ãž', 'Þ', [rfReplaceAll]);
     Result := StringReplace(Result, 'ÃŸ', 'ß', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã ', 'à', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã¡', 'á', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã¢', 'â', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã£', 'ã', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã¤', 'ä', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã¥', 'å', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã¦', 'æ', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã§', 'ç', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã¨', 'è', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã©', 'é', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ãª', 'ê', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã«', 'ë', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã¬', 'ì', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã­', 'í', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã®', 'î', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã¯', 'ï', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã°', 'ð', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã±', 'ñ', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã²', 'ò', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã³', 'ó', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã´', 'ô', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ãµ', 'õ', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã¶', 'ö', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã·', '÷', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã¸', 'ø', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã¹', 'ù', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ãº', 'ú', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã»', 'û', [rfReplaceAll]);
     Result := stringReplace(Result, 'Ã¼', 'ü', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã½', 'ý', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã¾', 'þ', [rfReplaceAll]);
     Result := StringReplace(Result, 'Ã¿', 'ÿ', [rfReplaceAll]);
end;

//-------------------------------------------------------------------------------------------------------------------
function AjustaChrHTML(const Texto: string): string;
begin
     Result := Texto;
     Result := stringReplace(Result, '&quot;'  , '"', [rfReplaceAll]);
     Result := stringReplace(Result, '&amp;'   , '&', [rfReplaceAll]);
     Result := stringReplace(Result, '&lt;'    , '>', [rfReplaceAll]);
     Result := stringReplace(Result, '&gt;'    , '<', [rfReplaceAll]);
     Result := stringReplace(Result, '&nbsp;'  , ' ', [rfReplaceAll]);
     Result := stringReplace(Result, '&uml;'   , '¨', [rfReplaceAll]);
     Result := stringReplace(Result, '&ordf;'  , 'ª', [rfReplaceAll]);
     Result := stringReplace(Result, '&deg;'   , 'º', [rfReplaceAll]);
     Result := stringReplace(Result, '&Ccedil;', 'Ç', [rfReplaceAll]);
     Result := stringReplace(Result, '&ccedil;', 'ç', [rfReplaceAll]);
     Result := stringReplace(Result, '&Ntilde;', 'Ñ', [rfReplaceAll]);
     Result := stringReplace(Result, '&ntilde;', 'ñ', [rfReplaceAll]);
end;

//-------------------------------------------------------------------------------------------------------------------
function AjustaChrUTF8(const Texto: string): string;
begin
     Result := Texto;
     Result := stringReplace(Result, '\u00c0', 'À', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c1', 'Á', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c2', 'Â', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c3', 'Ã', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c4', 'Ä', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c5', 'Å', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c6', 'Æ', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c7', 'Ç', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c8', 'È', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00c9', 'É', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00ca', 'Ê', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00cb', 'Ë', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00cc', 'Ì', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00cd', 'Í', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00ce', 'Î', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00cf', 'Ï', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00d1', 'Ñ', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00d2', 'Ò', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00d3', 'Ó', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00d4', 'Ô', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00d5', 'Õ', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00d6', 'Ö', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00d8', 'Ø', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00d9', 'Ù', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00da', 'Ú', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00db', 'Û', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00dc', 'Ü', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00dd', 'Ý', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00df', 'ß', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e0', 'à', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e1', 'á', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e2', 'â', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e3', 'ã', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e4', 'ä', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e5', 'å', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e6', 'æ', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e7', 'ç', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e8', 'è', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00e9', 'é', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00ea', 'ê', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00eb', 'ë', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00ec', 'ì', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00ed', 'í', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00ee', 'î', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00ef', 'ï', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f0', 'ð', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f1', 'ñ', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f2', 'ò', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f3', 'ó', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f4', 'ô', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f5', 'õ', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f6', 'ö', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f8', 'ø', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00f9', 'ù', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00fa', 'ú', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00fb', 'û', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00fc', 'ü', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00fd', 'ý', [rfReplaceAll]);
     Result := stringReplace(Result, '\u00ff', 'ÿ', [rfReplaceAll]);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetTaxaFin(ATaxaMes : Extended; ADias: Extended) : Extended;
begin
     result :=  power((1 + (ATaxaMes / 100)), (ADias / 30));
end;

//-------------------------------------------------------------------------------------------------------------------
function RetPerFin(ATaxaMes : Extended; ADias: Extended) : Extended;
begin
     result :=  (FH.RetTaxaFin(ATaxaMes,ADias) - 1) * 100;
end;

//-------------------------------------------------------------------------------------------------------------------
function EqualizaFin(AValor, ATaxaMes : Extended; ADias: Extended; ASinal:string = '*') : Extended;
begin
     if ASinal = '/' then
        result := AValor / FH.RetTaxaFin(ATaxaMes,ADias)
     else
        result := AValor * FH.RetTaxaFin(ATaxaMes,ADias);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure LimpaNulosArquivo(const pArquivo: String);
var  FileIn  ,
     FileOut : TextFile;
     C       : AnsiChar;
     ok      : Boolean ;
     s       : string;
begin
     ok := False ;
     AssignFile(FileIn, pArquivo);
     Reset(FileIn);
     while not EOF(FileIn) do
     begin
          Read(FileIn, C);
          if C = #0 then
          begin
               ok := True ;
               break ;
          end;
     end;
     if ok then
     begin
          s := FH.AdicionaDelimitador( ExtractFilePath( pArquivo ) ) + 'temp_' + ExtractFileName( pArquivo );
          AssignFile(FileOut, s);
          ReWrite(FileOut);

          Reset(FileIn);
          while not EOF(FileIn) do
          begin
               Read(FileIn, C);
               if C = #0 then
                 Write(FileOut, #32)
               else
                 Write(FileOut, C)
          end;
          CloseFile(FileOut);
          CloseFile(FileIn);
          if SysUtils.DeleteFile( pArquivo ) then
             FH.RenomeiaArquivo( s, pArquivo );
     end
     else
         CloseFile(FileIn);
end;

//-------------------------------------------------------------------------------------------------------------------
function VerCelular(const PNumero: string): Boolean ;
var
     n : string;
begin
     Result := False;
     if PNumero > '' then
     begin
          if pos(')', PNumero) > 0 then
             n := Copy(FH.CopyPosMax(PNumero, ')'), 1, 1)
          else
             n := Copy(PNumero, 1, 1);
          Result := (n = '8') or (n = '9');
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function SemData( const Data1, Data2 : string ) : Boolean ;
begin
     Result := ( FH.DataInvalida( Data1 ) and FH.DataInvalida( Data2 ) )
            or ( FH.DataInvalida( Data1 ) and FH.DataOK      ( Data2 ) )
            or ( FH.DataOK      ( Data1 ) and FH.DataInvalida( Data2 ) ) ;
end;

//-------------------------------------------------------------------------------------------------------------------
function Concatenar(PStrings: array of string; const PSeparador: string; const PDistintos: Boolean = False): string;
const
     k = '<##>';
var
     i : Integer;
     s : string;
begin
     Result := '';
     s      := '';
     for i  := low(PStrings) to high(PStrings) do
     begin
          if trim(PStrings[i]) <> '' then
          begin
               if PDistintos then
               begin
                    if pos(k + PStrings[i] + k, s) > 0 then
                       continue;
                    s := s + k + PStrings[i] + k;
               end;
               if Result <> '' then
                  Result := Result + PSeparador;
               Result := Result + PStrings[i];
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function VarTemConteudo(const V: Variant): Boolean;
begin
     Result := False;
     if not VarIsNull(V) then
        if VarToStr(V) > '' then
           Result := True;
end;

//-------------------------------------------------------------------------------------------------------------------
function VarParaStr(const V: Variant): string;
begin
     Result := '';
     if not VarIsNull(V) then
        Result := VarToStr(V);
end;

//-------------------------------------------------------------------------------------------------------------------
function Coalesce(const Valores: array of string): string;
var
     i : Integer;
begin
     Result := '';
     for i := Low(Valores) to High(Valores) do
         if FH.StrOk(Valores[i]) then
         begin
              Result := Valores[i];
              Exit;
         end;
end;

//-------------------------------------------------------------------------------------------------------------------
function CopyEntre(const PStr, PTagIni, PTagFin: string; const PTrim: Boolean = true): string;
begin
     Result := '';
     if FH.Contem(PStr, PTagIni) and FH.Contem(PStr, PTagFin) then
     begin
          Result := FH.CopyPosMax(PStr  , PTagIni, PTrim);
          Result := FH.CopyPos   (Result, PTagFin, PTrim);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IncExclusivo(Lista: TStrings; const S: string; const VerificarSemQuebras: Boolean = False);
var
    t, n: string;
begin
    if VerificarSemQuebras then
    begin
         t := FH.LimpaQuebrasTrim(Lista.Text);
         n := FH.LimpaQuebrasTrim(S);
         if FH.NaoContem(t, n) then
            Lista.Add(S);
    end
    else
    if Lista.IndexOf(S) = -1 then
       Lista.Add(S);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure IncExclusivo(CB: TComboBox; const S: string);
begin
    FH.IncExclusivo(CB.Items, S);
end;

//-------------------------------------------------------------------------------------------------------------------
function MinDate(const A, B: TDateTime): TDateTime;
begin
     if A < B then
        Result := A
     else
        Result := B;
end;

//-------------------------------------------------------------------------------------------------------------------
function MaxDate(const A, B: TDateTime): TDateTime;
begin
     if A > B then
        Result := A
     else
        Result := B;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaEnabledDataSet(DS: TDataSet; PCampos: array of TComponent);
var
     I: integer;
begin
     try
        for I := Low(PCampos) to High(PCampos) do
        begin
             if PCampos[I] is TMenuItem then
                TMenuItem(PCampos[I]).Enabled := not DS.IsEmpty
             else
             if PCampos[I] is TControl then
                TControl(PCampos[I]).Enabled := not DS.IsEmpty
        end;
     except

     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetNivelAnterior(const S: string): string;
var
     i         : integer;
     vStr      : string;
     vTerminou,
     vTrocou   : Boolean;
begin
     Result    := '';
     vTrocou   := False;
     vTerminou := False;
     for i := Length(S) downto 1 do
     begin
         vStr := Copy(S, i, 1);
         if vStr = '.' then
         begin
            if vTrocou then
               vTerminou := True;
         end
         else
         if (vStr > '0') and (not vTerminou) then
         begin
            vTrocou := True;
            vStr    := '0';
         end;

         Result := vStr + Result;
     end;

end;

//-------------------------------------------------------------------------------------------------------------------
function RetNivel(const S: string): Integer;
var
     i         : integer;
     vStr      : string;
begin
     Result := RetNivelMaior(s);
     for i := Length(S) downto 1 do
     begin
         vStr := Copy(S, i, 1);
         if vStr = '.' then
            Dec(Result)
         else
         if vStr > '0' then
            Exit;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function RetNivelMaior(const S: string): Integer;
begin
     Result := FH.ContaStr(s, '.') + 1;
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaHoraValida(const SHoras: string): string;
var
     s, h, m : string;
begin
     s := StringReplace(SHoras, ',', ':', []);
     s := StringReplace(s, '.', ':', []);
     if FH.Contem(s, ':') then
     begin
          h := FH.StrInteiro(FH.CopyPos(s, ':'));
          m := FH.StrInteiro(FH.CopyPosMax(s, ':'));
     end
     else
     begin
          h := FH.StrInteiro(s);
          m := '00';
     end;
     if Length(h) < 2 then
        h := FH.StrZero(h, 2);
     if Length(m) < 2 then
     begin
          if Length(m) = 1 then
             m := m + '0'
          else
             m := FH.StrZero(m, 2);
     end;
     if strtoint(m) > 59 then
        m := '59';
     Result := h + ':' + m;
end;

//-------------------------------------------------------------------------------------------------------------------
function HoraStrParaFloat(const PValor: string): Extended;
begin
     if pos(':', PValor) > 0 then
     begin
          Result := StrToFloat(FH.CopyPos(PValor, ':')) + (StrToFloat(FH.CopyPosMax(PValor, ':'))/60);
     end
     else
         Result := StrToFloat(PValor);
end;

//-------------------------------------------------------------------------------------------------------------------
function FloatParaHoraStr(const PValor: Extended): string;
var
     q, t: Extended;
begin
     q := PValor;
     t := frac(q);
     if t > 0 then
        t := int(q) + (t * 0.6)
     else
        t := q;
     Result := StringReplace(FH.FmtFix(t), ',', ':', []);
end;

//-------------------------------------------------------------------------------------------------------------------
function FloatParaHoraStr(const PValor: string): string;
var
     s: string;
     q, t: Extended;
begin
     s := PValor;
     if FH.FloatOk(s) then
     begin
          q := StrToFloat(s);
          t := frac(q);
          if t > 0 then
             t := int(q) + (t * 0.6)
          else
             t := q;
          s := StringReplace(FH.FmtFix(t), ',', ':', []);
          if Length(s) < 5 then
             s := FH.StrZero(s, 5);
          result := s;
     end
     else
         result := PValor;
end;

//-------------------------------------------------------------------------------------------------------------------
function MenorQueZero(const v: Extended): Boolean;
begin
     Result := Copy(FH.FmtFix(v), 1, 1) = '-';
end;

//-------------------------------------------------------------------------------------------------------------------
function MaiorQueZero(const v: Extended; const Decimais: Smallint = 2): Boolean;
begin
     Result := (FH.FmtFix(v, Decimais) <> '0,00') and (Copy(FH.FmtFix(v, Decimais), 1, 1) <> '-');
end;

//-------------------------------------------------------------------------------------------------------------------
function SeMaiorqueZero(const PVal, PDefault: Extended; const Decimais: Smallint = 2): Extended;
begin
     Result := PDefault;
     if FH.MaiorQueZero(PVal, Decimais) then
        Result := PVal;
end;

//-------------------------------------------------------------------------------------------------------------------
function MultiploOK (const n1, n2: Extended) : Boolean;
var
     vAux : Real;
begin
     vAux   := SafeDiv(n1,n2);
     Result := FH.FmtNum(vAux) = FH.FmtNum(Int(vAux));
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaListaValores(const Valores: array of string): string;
var
     i, m : Smallint;
     u    : Boolean;
begin
     Result := '';
     u := True;
     m := 0;
     for i := 0 to high(Valores) do
     begin
          if u then
             m := Max(m, Length(Valores[i]));
          u := not u;
     end;
     u := True;
     for i := 0 to high(Valores) do
     begin
          if u then
          begin
               if Result > '' then
                  Result := Result + CRLF;
               Result := Result + FH.PreencheDir(valores[i], m) + ' : ';
          end
          else
             Result := Result + valores[i];
          u := not u;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaListaValores(const Valores: TStrings): string;
var
     i, m : Smallint;
     u    : Boolean;
begin
     Result := '';
     u := True;
     m := 0;
     for i := 0 to Valores.Count - 1 do
     begin
          if u then
             m := Max(m, Length(Valores[i]));
          u := not u;
     end;
     u := True;
     for i := 0 to Valores.Count - 1 do
     begin
          if u then
          begin
               if Result > '' then
                  Result := Result + CRLF;
               Result := Result + FH.PreencheDir(valores[i], m) + ' : ';
          end
          else
             Result := Result + valores[i];
          u := not u;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure ChamaPopupMenu(PComponente: TControl; PPopupMenu: TPopupMenu);
var
     P : TPoint;
begin
     P.X := 0;
     P.Y := PComponente.Height;
     P   := PComponente.ClientToScreen(P);
     PPopupMenu.Popup(P.X, P.Y);
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaReplaceLimpaSQL(const PCampo: string; PSimbolos: array of string): string;
var
     i: Integer;
begin
     Result := '';
     for i := low(PSimbolos) to High(PSimbolos) do
     begin
          if Result = '' then
             Result := Format( 'REPLACE(%s, %s, %s)', [PCampo, QuotedStr(PSimbolos[i]), QuotedStr('')])
          else
             Result := Format( 'REPLACE(%s, %s, %s)', [Result, QuotedStr(PSimbolos[i]), QuotedStr('')]);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaReplaceLimpaSQLInt(const PCampo: string): string;
begin
     Result := FH.MontaReplaceLimpaSQL(PCampo, ['0','1','2','3','4','5','6','7','8','9']);
end;

//-------------------------------------------------------------------------------------------------------------------
function CorClara(PCor: TColor): Boolean;
begin
     PCor := ColorToRGB(PCor);
     Result := ((PCor and $FF) + (PCor shr 8 and $FF) + (PCor shr 16 and $FF)) >= $180;
end;

//-------------------------------------------------------------------------------------------------------------------
function StringToHex(const S: string): string;
var
     I: Integer;
begin
     Result := '';
     for I := 1 to length( S ) do
         Result:= Result + IntToHex( ord( S[ i ] ), 2 ) ;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure CentralizaWinControl(PWc, PContainer: TWinControl; const PVisible: Boolean);
begin
     PWc.Left    := (PContainer.Width  div 2) - (PWc.Width  div 2);
     PWc.Top     := (PContainer.Height div 2) - (PWc.Height div 2);
     PWc.Visible := PVisible;
     if PVisible then
        PWc.BringToFront;
end;

//-------------------------------------------------------------------------------------------------------------------
function DataXMLParaDataPadrao(const pData: string): string;
var
     s: string;
begin
     s := pData;
     if s <> '' then
     begin
          if Copy(s, 5, 1) = '-' then
             s := trim(Copy(s, 9, 2) + '/' + Copy(s, 6, 2) + '/' + Copy(s, 1, 4) + ' ' + Copy(s, 12, 8));
     end;
     Result := Trim(s);
end;

//-------------------------------------------------------------------------------------------------------------------
function InsereAspasLista(const S: string): string;
var
     st : string;
     L: TStrings;
begin
     st := s;
     Result := '';
     L := TStringList.Create;
     try
        FH.StrParaLista(S, L);
        for st in L do
            FH.FormaLista(Result, QuotedStr(st), True, False, False);
     finally
        L.Free;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaEnabledBotaoSairForm(FR: TForm; const PEstado: Boolean);
begin
     EnableMenuItem(GetSystemMenu(FR.Handle, LongBool(PEstado)), SC_CLOSE, MF_BYCOMMAND or MF_GRAYED);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetHostName(aIp:string):string;
var
    IdStackWin: TIdStackWindows;
begin
    IdStackWin := TIdStackWindows.Create;
    try
      try
          result := IdStackWin.HostByAddress(aIp);
      except
          Result := 'Host não encontrado';
      end;
    finally
        IdStackWin.Free;
    end;
end;

//-------------------------------------------------------------------------------------------------------------------
function SetaPrimeiraLetraMaiuscula(const pTexto: string): string;
begin
     Result := FH.SetaUpper(pTexto, 1);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaPrimeiraLetraMaiuscula(const Edit: TCustomEdit; var Key: Char);
begin
     if (Length(trim(Edit.Text)) = 0) or (Edit.SelStart = 0) then
        if CharInSet(Key, ['a'..'z']) then
           Dec(Key, 32);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaPrimeiraLetraMaiuscula(const Texto: string; var Key: Char);
begin
     if (Length(trim(Texto)) = 0) then
        if CharInSet(key, ['a'..'z']) then
           dec(key, 32);
end;

//-------------------------------------------------------------------------------------------------------------------
function ValidaCampoInteiro(Campo: TCustomMaskEdit; const Msg: string = 'Código inválido.'): Boolean ;
begin
     Result := True;
     Campo.Text := trim(Campo.Text);
     if Campo.Text = '' then
        Exit;
     if FH.TemInteiro(Campo.Text) then
     begin
          if not FH.Int32Ok(Campo.Text) then
          begin
               Result := False;
               FH.PrMsg_Focalize(Campo, Msg);
          end;
     end
     else
     begin
          Result := False;
          FH.PrMsg_Focalize(Campo, Msg);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ValidaCampoInt64(Campo: TCustomMaskEdit; const Msg: string = 'Código inválido.'): Boolean ;
begin
     Result := True;
     Campo.Text := trim(Campo.Text);
     if Campo.Text = '' then
        Exit;
     if FH.TemInteiro(Campo.Text) then
     begin
          if not FH.Int64Ok(Campo.Text) then
          begin
               Result := False;
               FH.PrMsg_Focalize(Campo, Msg);
          end;
     end
     else
     begin
          Result := False;
          FH.PrMsg_Focalize(Campo, Msg);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure DescarregaMemoriaApp;
var
     MainHandle : THandle;
begin
     try
        MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
        SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
        CloseHandle(MainHandle) ;
     except
     end;
     Application.ProcessMessages;
end;

//-------------------------------------------------------------------------------------------------------------------
function MontaFmtDataPadraoSQL(const ACampo: string): string;
begin
     result := format('lpad(extract(day from %s),2,''0'')||''/''||lpad(extract(month from %s),2,''0'')||''/''||extract(year from %s)', [ACampo, ACampo, ACampo]);
end;

//-------------------------------------------------------------------------------------------------------------------
function PorCento(const PValor, PPercentual: Double; const PArredondaDecimal: Smallint = 2): Extended;
begin
     result := FH.ArredondaValor(FH.CalcPorcentagem(PValor, PPercentual), PArredondaDecimal);
end;

//-------------------------------------------------------------------------------------------------------------------
function InTags(const Tags, Valor: string): Boolean;
begin
     Result := FH.Contem(Tags, '<' + Valor + '>');
end;

//-------------------------------------------------------------------------------------------------------------------
procedure MontaTags(var Tags: string; const Valor: string);
begin
     Tags := Tags + '<' + Valor + '>';
end;

//-------------------------------------------------------------------------------------------------------------------
procedure MontaTags(var Tags: string; DS: TDataSet; const Campo: string; const Exclusivo: Boolean = False);
var
     v: string;
begin
     DS.first;
     while not DS.eof do
     begin
          v := DS.FieldByName(Campo).AsString;
          if Exclusivo then
          begin
               if not FH.InTags(Tags, v) then
                  FH.MontaTags(Tags, v);
          end
          else
              FH.MontaTags(Tags, v);
          DS.next;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ListaStrParaTags(const StrLista: string): string;
begin
     if trim(StrLista)='' then
        Exit;
     Result := '<' + StringReplace(StrLista, ',', '><', [rfReplaceAll]) + '>';
end;

//-------------------------------------------------------------------------------------------------------------------
function MemoryStreamParaString(M: TMemoryStream): string;
begin
     SetString(Result, PAnsiChar(M.Memory), M.Size);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure StrParaStream(const Stream: TStream; Value: AnsiString);
begin
     Stream.Write(PAnsiChar(Value)^, Length(Value));
end;

//-------------------------------------------------------------------------------------------------------------------
function EntrePar(const PStr: string; const PEspacos: smallint = 0): string;
var
     n: string;
begin
     n := '';
     if PEspacos > 0 then
        n := DupeString(FH.UM_ESPACO, PEspacos);
     Result := '(' + n + PStr + n + ')';
end;

//-------------------------------------------------------------------------------------------------------------------
function EntreAspas(const S: string): string;
begin
     Result := FH.ASPAS_DUPLAS + S + FH.ASPAS_DUPLAS;
end;

//-------------------------------------------------------------------------------------------------------------------
function VerTagBtn(C: TComponent): Boolean;
begin
     Result := C.Tag = 1;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaTagBtn(C: TComponent; Ativado: Boolean);
begin
     with C do Tag := FH.SeSenao(Ativado, 1, 0);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure InverteTagBtn(C: TComponent);
begin
     with C do Tag := FH.SeSenao(Tag = 0, 1, 0);
end;

//-------------------------------------------------------------------------------------------------------------------
function RetIPLocal : string;
type
   TaPInAddr = array [0..10] of PInAddr;
   PaPInAddr = ^TaPInAddr;
var
    phe: PHostEnt;
    pptr: PaPInAddr;
    Buffer: array [0..63] of ansichar;
    i: Integer;
    GInitData: TWSADATA;
begin
    WSAStartup($101, GInitData);
    Result := '';
    GetHostName(Buffer, SizeOf(Buffer));
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
    pptr := PaPInAddr(Phe^.h_addr_list);
    i := 0;
    while pptr^[i] <> nil do
    begin
      result:=StrPas(inet_ntoa(pptr^[i]^));
      Inc(i);
    end;
    WSACleanup;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaCheckedNegrito(PCheckBox: TCheckBox);
begin
     if PCheckBox.Checked then
        PCheckBox.Font.Style := [fsBold]
     else
        PCheckBox.Font.Style := [];
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SetaTamanhoForm(FR1, FR2: TForm);
begin
     FR2.Left := FR1.Left;
     FR2.Top := FR1.Top;
     FR2.Height := FR1.Height;
     FR2.Width := FR1.Width;
end;

//-------------------------------------------------------------------------------------------------------------------
function PrimeiroDiaTrimestre(const PData: TDateTime): string;
begin
     Result := '';
     case monthof(PData) of
          1,2,3 :
          begin
               Result := DateToStr(RecodeDate(PData, YearOf(PData), 1, 1));
          end;
          4,5,6 :
          begin
               Result := DateToStr(RecodeDate(PData, YearOf(PData), 4, 1));
          end;
          7,8,9 :
          begin
               Result := DateToStr(RecodeDate(PData, YearOf(PData), 7, 1));
          end;
          10,11,12 :
          begin
               Result := DateToStr(RecodeDate(PData, YearOf(PData), 10, 1));
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function UltimoDiaTrimestre(const PData: TDateTime): string;
begin
     Result := '';
     case monthof(PData) of
          1,2,3 :
          begin
               Result := DateToStr(RecodeDate(PData, YearOf(PData), 3, 31));
          end;
          4,5,6 :
          begin
               Result := DateToStr(RecodeDate(PData, YearOf(PData), 6, 30));
          end;
          7,8,9 :
          begin
               Result := DateToStr(RecodeDate(PData, YearOf(PData), 9, 30));
          end;
          10,11,12 :
          begin
               Result := DateToStr(RecodeDate(PData, YearOf(PData), 12, 31));
          end;
     end;
end;

{ TImgResizer }

class function TImgResizer.Redimensionar(APicOrigem, APicDestino: TPicture; const AProporcaoPercentual: Double;
  const AExtensao: string; const ACaminhoArquivo: string = ''): Int64;
var
     rt                              : TRect;
     jpgOriginal, jpgNovo            : TJPEGImage;
     bmpOriginal, bmpNovo, tmpBitmap : TBitmap;
     mStream                         : TMemoryStream;
     intAlt, intLar                  : Integer;
     pngNovo                         : TPngImage;
     strExtensao                     : string;

     procedure ReduzirJPG;
     begin
          tmpBitmap := TBitmap.Create;
          jpgOriginal := TJPEGImage.Create;
          jpgNovo := TJPEGImage.Create;
          try
               if (AnsiSameText(APicOrigem.Graphic.ClassName, 'TdxSmartImage')) and (ACaminhoArquivo <> '') then
               begin
                    // devido a incompatibilidade entre a classe TdxSmartImage e a TJPEGImage,
                    // tem que carregar o objeto através do último arquivo
                    jpgOriginal.LoadFromFile(ACaminhoArquivo);
               end
               else
               begin
                    // depois da carga inicial ou redução,
                    // o "Graphic" do componente assume a classe TJPEGImage ao invés do TdxSmartImage
                    jpgOriginal.Assign(APicOrigem.Graphic);
               end;
               bmpOriginal := TBitmap.Create;
               try
                  bmpOriginal.Assign(jpgOriginal);
                  tmpBitmap.Width  := trunc(bmpOriginal.Width * (AProporcaoPercentual / 100));
                  tmpBitmap.Height := MulDiv(trunc(bmpOriginal.Width * (AProporcaoPercentual / 100)), bmpOriginal.Height, bmpOriginal.Width);
                  Self.SmoothResizeBMP(bmpOriginal, tmpBitmap);
               finally
                      bmpOriginal.Free;
               end;
               jpgNovo.Assign(tmpBitmap);
               APicDestino.Assign(jpgNovo);
               mStream := TmemoryStream.Create;
               try
                    jpgNovo.SaveToStream(mStream);
                    Result := mStream.Size;
               finally
                    mStream.Free;
               end;
          finally
               tmpBitmap.Free;
               jpgOriginal.Free;
               jpgNovo.Free;
          end;
     end;

     procedure ReduzirPNG;
     begin
          pngNovo := TPngImage.Create;
          try
               if (AnsiSameText(APicOrigem.Graphic.ClassName, 'TdxSmartImage')) and (ACaminhoArquivo <> '') then
                  pngNovo.LoadFromFile(ACaminhoArquivo)
               else
                  pngNovo.Assign(APicOrigem.Graphic);
               Self.SmoothResizePNG(pngNovo, trunc(pngNovo.Width * (AProporcaoPercentual / 100)), trunc(pngNovo.Height * (AProporcaoPercentual / 100)));
               APicDestino.Assign(pngNovo);
               mStream := TmemoryStream.Create;
               try
                    pngNovo.SaveToStream(mStream);
                    Result := mStream.Size;
               finally
                    mStream.Free;
               end;
          finally
               pngNovo.Free;
          end;
     end;

     procedure ReduzirBMP;
     begin
          tmpBitmap := TBitmap.Create;
          bmpOriginal := TBitmap.Create;
          bmpNovo := TBitmap.Create;
          try
               if (AnsiSameText(APicOrigem.Graphic.ClassName, 'TdxSmartImage')) and (ACaminhoArquivo <> '') then
                  bmpOriginal.LoadFromFile(ACaminhoArquivo)
               else
                  bmpOriginal.Assign(APicOrigem.Graphic);
               tmpBitmap.Assign(bmpOriginal);
               intAlt := trunc(tmpBitmap.Height * (AProporcaoPercentual / 100));
               intLar := trunc(tmpBitmap.Width * (AProporcaoPercentual / 100));
               rt.Left := 0;
               rt.Top := 0;
               if tmpBitmap.Width > tmpBitmap.Height then
               begin
                    rt.Right := intLar;
                    rt.Bottom := (intLar * tmpBitmap.Height) div tmpBitmap.Width;
               end
               else
               begin
                    rt.Bottom := intAlt;
                    rt.Right := (intAlt * tmpBitmap.Width) div tmpBitmap.Height;
               end;
               tmpBitmap.Canvas.StretchDraw(rt, tmpBitmap);
               tmpBitmap.Width := rt.Right;
               tmpBitmap.Height := rt.Bottom;
               bmpNovo.Assign(tmpBitmap);
               APicDestino.Assign(bmpNovo);
               mStream := TmemoryStream.Create;
               try
                    bmpNovo.SaveToStream(mStream);
                    Result := mStream.Size;
               finally
                    mStream.Free;
               end;
          finally
               tmpBitmap.Free;
               bmpOriginal.Free;
               bmpNovo.Free;
          end;
     end;

begin
     Result := 0;
     strExtensao := AExtensao;
     if (strExtensao = Emptystr) and (ExtractFileExt(ACaminhoArquivo) <> EmptyStr) then
        strExtensao := FH.LimpaPonto(ExtractFileExt(ACaminhoArquivo));

     if AnsiSameText(strExtensao, 'JPG') then
        ReduzirJPG
     else
     if AnsiSameText(strExtensao, 'BMP') then
        ReduzirBMP
     else
     if AnsiSameText(strExtensao, 'PNG') then
        ReduzirPNG
     else
     if strExtensao = EmptyStr then
     begin
          try
             ReduzirJPG;
          except
                try
                   ReduzirPNG;
                except
                      try
                         ReduzirBMP;
                      except
                            //
                      end;
                end;
          end;
     end;
end;

class procedure TImgResizer.SmoothResizeBMP(Src, Dst: TBitmap);
var
     x, y: Integer;
     xP, yP: Integer;
     xP2, yP2: Integer;
     SrcLine1, SrcLine2: pRGBArray;
     t3: Integer;
     z, z2, iz2: Integer;
     DstLine: pRGBArray;
     DstGap: Integer;
     w1, w2, w3, w4: Integer;
begin
     Src.PixelFormat := pf24Bit;
     Dst.PixelFormat := pf24Bit;
     if (Src.Width = Dst.Width) and (Src.Height = Dst.Height) then
        Dst.Assign(Src)
     else
     begin
          DstLine := Dst.ScanLine[0];
          DstGap  := Integer(Dst.ScanLine[1]) - Integer(DstLine);
          xP2 := MulDiv(pred(Src.Width), $10000, Dst.Width);
          yP2 := MulDiv(pred(Src.Height), $10000, Dst.Height);
          yP  := 0;
          for y := 0 to pred(Dst.Height) do
          begin
               xP := 0;
               SrcLine1 := Src.ScanLine[yP shr 16];
               if (yP shr 16 < pred(Src.Height)) then
                  SrcLine2 := Src.ScanLine[succ(yP shr 16)]
               else
                  SrcLine2 := Src.ScanLine[yP shr 16];
               z2  := succ(yP and $FFFF);
               iz2 := succ((not yp) and $FFFF);
               for x := 0 to pred(Dst.Width) do
               begin
                    t3 := xP shr 16;
                    z  := xP and $FFFF;
                    w2 := MulDiv(z, iz2, $10000);
                    w1 := iz2 - w2;
                    w4 := MulDiv(z, z2, $10000);
                    w3 := z2 - w4;
                    DstLine[x].rgbtRed := (SrcLine1[t3].rgbtRed * w1 +
                                          SrcLine1[t3 + 1].rgbtRed * w2 +
                                          SrcLine2[t3].rgbtRed * w3 + SrcLine2[t3 + 1].rgbtRed * w4) shr 16;
                    DstLine[x].rgbtGreen := (SrcLine1[t3].rgbtGreen * w1 + SrcLine1[t3 + 1].rgbtGreen * w2 +
                                            SrcLine2[t3].rgbtGreen * w3 + SrcLine2[t3 + 1].rgbtGreen * w4) shr 16;
                    DstLine[x].rgbtBlue := (SrcLine1[t3].rgbtBlue * w1 + SrcLine1[t3 + 1].rgbtBlue * w2 +
                                           SrcLine2[t3].rgbtBlue * w3 + SrcLine2[t3 + 1].rgbtBlue * w4) shr 16;
                    Inc(xP, xP2);
               end; {for}
               Inc(yP, yP2);
               DstLine := pRGBArray(Integer(DstLine) + DstGap);
          end; {for}
     end; {if}
end;

class procedure TImgResizer.SmoothResizePNG(apng: TPngImage; NewWidth, NewHeight: integer);
var
     xscale, yscale          : Single;
     sfrom_y, sfrom_x        : Single;
     ifrom_y, ifrom_x        : Integer;
     to_y, to_x              : Integer;
     weight_x, weight_y      : array[0..1] of Single;
     weight                  : Single;
     new_red, new_green      : Integer;
     new_blue, new_alpha     : Integer;
     new_colortype           : Integer;
     total_red, total_green  : Single;
     total_blue, total_alpha : Single;
     IsAlpha                 : Boolean;
     ix, iy                  : Integer;
     bTmp                    : TPngImage;
     sli, slo                : pRGBLine;
     ali, alo                : pbytearray;
begin
     if not (apng.Header.ColorType in [COLOR_RGBALPHA, COLOR_RGB]) then
          raise Exception.Create('Only COLOR_RGBALPHA and COLOR_RGB formats are supported');
     IsAlpha := apng.Header.ColorType in [COLOR_RGBALPHA];
     if IsAlpha then
          new_colortype := COLOR_RGBALPHA
     else
          new_colortype := COLOR_RGB;
     bTmp := TPngImage.CreateBlank(new_colortype, 8, NewWidth, NewHeight);
     xscale := bTmp.Width / (apng.Width - 1);
     yscale := bTmp.Height / (apng.Height - 1);
     for to_y := 0 to bTmp.Height - 1 do
     begin
          sfrom_y := to_y / yscale;
          ifrom_y := Trunc(sfrom_y);
          weight_y[1] := sfrom_y - ifrom_y;
          weight_y[0] := 1 - weight_y[1];
          for to_x := 0 to bTmp.Width - 1 do
          begin
               sfrom_x := to_x / xscale;
               ifrom_x := Trunc(sfrom_x);
               weight_x[1] := sfrom_x - ifrom_x;
               weight_x[0] := 1 - weight_x[1];

               total_red := 0.0;
               total_green := 0.0;
               total_blue := 0.0;
               total_alpha := 0.0;
               for ix := 0 to 1 do
               begin
                    for iy := 0 to 1 do
                    begin
                         sli := apng.Scanline[ifrom_y + iy];
                         if IsAlpha then
                              ali := apng.AlphaScanline[ifrom_y + iy];
                         new_red := sli[ifrom_x + ix].rgbtRed;
                         new_green := sli[ifrom_x + ix].rgbtGreen;
                         new_blue := sli[ifrom_x + ix].rgbtBlue;
                         if IsAlpha then
                              new_alpha := ali[ifrom_x + ix];
                         weight := weight_x[ix] * weight_y[iy];
                         total_red := total_red + new_red * weight;
                         total_green := total_green + new_green * weight;
                         total_blue := total_blue + new_blue * weight;
                         if IsAlpha then
                              total_alpha := total_alpha + new_alpha * weight;
                    end;
               end;
               slo := bTmp.ScanLine[to_y];
               if IsAlpha then
                    alo := bTmp.AlphaScanLine[to_y];
               slo[to_x].rgbtRed := Round(total_red);
               slo[to_x].rgbtGreen := Round(total_green);
               slo[to_x].rgbtBlue := Round(total_blue);
               if isAlpha then
                    alo[to_x] := Round(total_alpha);
          end;
     end;
     apng.Assign(bTmp);
     bTmp.Free;
end;

type
  TSpecials = set of AnsiChar;
function EncodeTriplet(const Value: AnsiString; Delimiter: AnsiChar;
  Specials: TSpecials): AnsiString;
var
  n, l: Integer;
  s: AnsiString;
  c: AnsiChar;
begin
  SetLength(Result, Length(Value) * 3);
  l := 1;
  for n := 1 to Length(Value) do
  begin
    c := Value[n];
    if c in Specials then
    begin
      Result[l] := Delimiter;
      Inc(l);
      s := IntToHex(Ord(c), 2);
      Result[l] := s[1];
      Inc(l);
      Result[l] := s[2];
      Inc(l);
    end
    else
    begin
      Result[l] := c;
      Inc(l);
    end;
  end;
  Dec(l);
  SetLength(Result, l);
end;

function EncodeURL(const Value: AnsiString): AnsiString;
const
     URLSpecialChar: TSpecials =
        [#$00..#$20, '<', '>', '"', '%', '{', '}', '|', '\', '^', '[', ']', '`', #$7F..#$FF];
begin
     Result := EncodeTriplet(Value, '%', URLSpecialChar);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure Navegar(const Endereco: string);
var
     u : string;
begin
     u := Trim(Endereco);
     if u <> '' then
     begin
          FH.SetaCursorAmp;
          try
                 u := FH.EncodeURL(u);
                 ShellExecute(0, 'open', PChar(u), nil, nil, SW_SHOWNORMAL);
          finally
                 FH.SetaCursorDef;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
procedure Navegar(FR: TForm; const Endereco: string);
begin
     if Trim(Endereco) > '' then
     begin
          FH.SetaCursorAmp;
          try
                 ShellExecute(FR.Handle, 'open', PChar(Endereco), nil, nil, SW_SHOWNORMAL);
          finally
                 FH.SetaCursorDef;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function SetXMLFloat(const ValorStr: string): Double;
var
     s : string;
begin
     Result := 0;
     s := trim(ValorStr);
     if s = '' then
        Exit;
     s := StringReplace(s, '.', FH.SeparadorDecimal, []);
     Result := StrToFloatDef(s, 0);
end;

//-------------------------------------------------------------------------------------------------------------------
function VerFone(PEditDDD, PEditFone: TEdit; PFocus: Smallint): Boolean;
var
     strFone: string;
begin
     Result := true;
     if PEditFone <> nil then
     begin
          strFone := StrInteiro(PEditFone.Text);
          if strFone = '' then
          begin
               if PEditDDD <> nil then
                  try PEditDDD.Clear; except end;
               exit;
          end;
     end;
     if PEditDDD <> nil then
     begin
          PEditDDD.Text := Trim(PEditDDD.Text);
          if (Length(PEditDDD.Text) > 0) and (not FH.IntOk(PEditDDD.Text)) then
          begin
               FH.PrMsg_AT('Informe apenas números para este campo.');
               FH.Focalize(PEditDDD);
               Result := false;
               exit;
          end;
          if PEditFone = nil then
             exit;
     end;
     if Length(strFone) < 7 then
     begin
          Result := false;
          FH.PrMsg_AT('Telefone inválido: menos de 7 dígitos');
          if PFocus = 0 then
             try FH.Focalize(PEditFone); except end;
          exit;
     end;
     System.Insert('-', strFone, Length(strFone) - 3);
     PEditFone.Text := strFone;
     // validação para o nono dígito de celulares
     strFone := FH.StrInteiro(strFone);
     if FH.Match(Copy(strFone, 1, 1), ['7', '8', '9']) then
     begin
          // validação para o nono dígito de celulares
          if Length(strFone) = 8 then
          begin
               if FH.PrMsg_CF('Número de Celular deve ter o Nono Dígito.'#13'Deseja verificar?', 2) = 1 then
               begin
                    Result := False;
                    try FH.Focalize(PEditFone); except end;
                    Exit;
               end;
          end
          else
          if Length(strFone) > 9 then
          begin
               Result := false;
               FH.PrMsg_AT('Telefone inválido: deve ter no máximo 9 dígitos.');
               if PFocus = 0 then
                  try FH.Focalize(PEditFone); except end;
               Exit;
          end;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function HorasToDec(st : string) : Double;
var
     HrVR   : Real ;
     HrCent : Real ;
begin
     HrVR   := StrToFloat(FH.CopyPos(st, ':') + ',' +FH.CopyPosMax(st, ':'));
     HrCent := int(hrvr)+((HrVr-Int(HrVr))/60*100);
     result := hrcent ;
end;

//-------------------------------------------------------------------------------------------------------------------
function Modulo10Itau(const PNumero, PAgencia, PConta, PCarteira: string): string;
var
     S, sNumero : string;
     P, I, vSoma, Resto  : Integer;
begin
     sNumero := FH.StrZero(FH.StrInteiro(PAgencia), 4) +
                FH.StrZero(FH.StrInteiro(PConta), 5) +
                FH.StrZero(FH.StrInteiro(PCarteira), 3) +
                PNumero;
     S := ReverseString(sNumero);
     P := 2;
     vSoma := 0;
     for I := 1 to Length(S) do
     begin
          Resto := P * StrToInt(S[I]);
          if Resto > 9 then
             Resto := StrToInt(Copy(IntToStr(Resto),1,1)) + StrToInt(Copy(IntToStr(Resto),2,1));
          vSoma := vSoma + Resto;
          if P = 2 then
             P := 1
          else
             P := 2;
     end;
     Resto := vSoma mod 10;
     p := 10 - Resto;
     if p >= 10 then
        p := 0;
     Result := IntToStr(p);
end;

//-------------------------------------------------------------------------------------------------------------------
function Modulo10Itau(const PNumero: string): string;
var
     S, sNumero : string;
     P, I, vSoma, Resto  : Integer;
begin
     sNumero := PNumero;
     S := ReverseString(sNumero);
     P := 2;
     vSoma := 0;
     for I := 1 to Length(S) do
     begin
          Resto := P * StrToInt(S[I]);
          if Resto > 9 then
             Resto := StrToInt(Copy(IntToStr(Resto),1,1)) + StrToInt(Copy(IntToStr(Resto),2,1));
          vSoma := vSoma + Resto;
          if P = 2 then
             P := 1
          else
             P := 2;
     end;
     Resto := vSoma mod 10;
     p := 10 - Resto;
     if p >= 10 then
        p := 0;
     Result := IntToStr(p);
end;

//-------------------------------------------------------------------------------------------------------------------
function Modulo11Base7(const S: string): string;
var
  ii, Peso, Soma: Integer;
begin
  result := '';
  Soma := 0;
  Peso := 2;
  for ii := Length(S) downto 1 do
  begin
    Soma := Soma + StrToInt(Copy(S, ii, 1)) * Peso;
    if Peso = 7 then
      Peso := 2
    else
      Inc(Peso);
  end;
  Soma := 11 - (Soma mod 11);

       if Soma = 10 then result := 'P'
  else if Soma = 11 then result := '0'
                    else result := IntToStr(Soma);
end;

//-------------------------------------------------------------------------------------------------------------------
function Modulo11BB (const PNumero: string): string;
var
     nro : string;
     P, I, vSoma, Resto : Integer;
begin
     nro := ReverseString(PNumero);
     P := 9;
     vSoma := 0;
     for I := 1 to Length(nro) do
     begin
       vSoma := vSoma + (P * StrToInt(nro[I]));
       dec(P);
       if P = 1 then
         P := 9;
     end;
     Resto := vSoma mod 11;
     if Resto < 10 then
        nro := IntToStr(Resto)
     else
     if Resto = 10 then
       nro := 'X'
     else
     if Resto = 0 then
       nro := '0';
     Result := nro;
end;

//-------------------------------------------------------------------------------------------------------------------
function CodIBGEParaUF(const aCodigo: string; const aUFDefault: string = 'RS'): string;
begin
     Result := aCodigo;
     if aCodigo = '11' then Result := 'RO' else
     if aCodigo = '12' then Result := 'AC' else
     if aCodigo = '13' then Result := 'AM' else
     if aCodigo = '14' then Result := 'RR' else
     if aCodigo = '15' then Result := 'PA' else
     if aCodigo = '16' then Result := 'AP' else
     if aCodigo = '17' then Result := 'TO' else
     if aCodigo = '21' then Result := 'MA' else
     if aCodigo = '22' then Result := 'PI' else
     if aCodigo = '23' then Result := 'CE' else
     if aCodigo = '24' then Result := 'RN' else
     if aCodigo = '25' then Result := 'PB' else
     if aCodigo = '26' then Result := 'PE' else
     if aCodigo = '27' then Result := 'AL' else
     if aCodigo = '28' then Result := 'SE' else
     if aCodigo = '29' then Result := 'BA' else
     if aCodigo = '31' then Result := 'MG' else
     if aCodigo = '32' then Result := 'ES' else
     if aCodigo = '33' then Result := 'RJ' else
     if aCodigo = '35' then Result := 'SP' else
     if aCodigo = '41' then Result := 'PR' else
     if aCodigo = '42' then Result := 'SC' else
     if aCodigo = '43' then Result := 'RS' else
     if aCodigo = '50' then Result := 'MS' else
     if aCodigo = '51' then Result := 'MT' else
     if aCodigo = '52' then Result := 'GO' else
     if aCodigo = '53' then Result := 'DF' else
                            Result := aUFDefault;
end;

//-------------------------------------------------------------------------------------------------------------------
function UFParaCodIBGE(const aUF: string; const aCodigoDefault: string = '43'): string;
begin
     Result := aUF;
     if aUF = 'RO' then Result := '11' else
     if aUF = 'AC' then Result := '12' else
     if aUF = 'AM' then Result := '13' else
     if aUF = 'RR' then Result := '14' else
     if aUF = 'PA' then Result := '15' else
     if aUF = 'AP' then Result := '16' else
     if aUF = 'TO' then Result := '17' else
     if aUF = 'MA' then Result := '21' else
     if aUF = 'PI' then Result := '22' else
     if aUF = 'CE' then Result := '23' else
     if aUF = 'RN' then Result := '24' else
     if aUF = 'PB' then Result := '25' else
     if aUF = 'PE' then Result := '26' else
     if aUF = 'AL' then Result := '27' else
     if aUF = 'SE' then Result := '28' else
     if aUF = 'BA' then Result := '29' else
     if aUF = 'MG' then Result := '31' else
     if aUF = 'ES' then Result := '32' else
     if aUF = 'RJ' then Result := '33' else
     if aUF = 'SP' then Result := '35' else
     if aUF = 'PR' then Result := '41' else
     if aUF = 'SC' then Result := '42' else
     if aUF = 'RS' then Result := '43' else
     if aUF = 'MS' then Result := '50' else
     if aUF = 'MT' then Result := '51' else
     if aUF = 'GO' then Result := '52' else
     if aUF = 'DF' then Result := '53' else
                        Result := aCodigoDefault;
end;

//-------------------------------------------------------------------------------------------------------------------
function ConverteDDMMAAParaData(const PData: string): string;
begin
     Result := PData;
     if Length(Result) = 8 then
        Result := Copy(Result, 1, 2) + '/' + Copy(Result, 3, 2) + '/' + Copy(Result, 5, 4);
end;

//-------------------------------------------------------------------------------------------------------------------
function GetCampoCsv(const ALinha: string; const APosicao: Integer): string;
var
     s: string;
     p, i: Integer;
begin
     s := ALinha;
     p := APosicao;
     if p < 1 then
        p := 1;
     for i := 1 to p do
     begin
          Result := FH.CopyPos(s, ';');
          s := FH.CopyPosMax(s, ';');
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function GeraImagemPrintScreen(const AArquivoSaida: string; const AQualidade: TJPEGQualityRange = 100): TJpegImage;
var
     objBmp : TBitmap;
     objJpg : TJpegImage;
     PC     : TPicture;
begin
     Result := nil;
     if not Clipbrd.Clipboard.HasFormat(CF_BITMAP) then
        Exit;
     objBmp := TBitmap.Create;
     objJpg := TJpegImage.Create;
     PC := TPicture.Create;
     try
        PC.Assign(Clipbrd.Clipboard);
        objBmp.Assign(PC.Bitmap);
        objJpg.Assign(objBmp);
        objJpg.CompressionQuality := AQualidade;
        if AArquivoSaida <> '' then
           objJpg.SaveToFile(AArquivoSaida);
        Result := objJpg;
     finally
        FreeandNil(objJpg);
        FreeAndNil(objBmp);
        FreeAndNil(PC);
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ValoresDiferentes(const PValor1, PValor2: extended; const pDec: Integer = 2): Boolean;
begin
     Result := not FH.ValoresIdenticos(PValor1, PValor2, pDec);
end;

//-------------------------------------------------------------------------------------------------------------------
function ArrayTemValor(const AArray: array of string): Boolean;
var
     i : Smallint;
begin
     Result := false;
     for i := Low(AArray) to High(AArray) do
         if FH.StrOk(AArray[i]) then
         begin
              Result := True;
              Exit;
         end;
end;

//-------------------------------------------------------------------------------------------------------------------
function IncDiaUtil(const PData: TDateTime; const PNroDias: Integer): TDateTime;
var
     d : TDateTime;
     i, total : Integer;
begin
     d := PData;
     if PNroDias = 0 then
     begin
          Result := d;
          Exit;
     end;
     total := Abs(PNroDias);
     for i := 1 to total do
     begin
          if PNroDias < 0 then
          begin
               d := IncDay(d, -1);
               d := FH.DiaUtilAnterior(d);
          end
          else
          begin
               d := IncDay(d, 1);
               d := FH.DiaUtilProximo(d);
          end;
     end;
     Result := d;
end;

//-------------------------------------------------------------------------------------------------------------------
function SetaMensagemValidacao(const ANomeCampo: string; const AMensagemPadrao: string = ''): string;
begin
     Result := '[ ' + trim(ANomeCampo) + ' ] : ' + FH.SeSenao(AMensagemPadrao <> '', AMensagemPadrao, FH.MSG_DEFAULT_VALIDACAO);
end;

//-------------------------------------------------------------------------------------------------------------------
function DataSetParaXML(ADS: TDataSet; const ACampos: array of string): string;
const
     TAG_RECORD = 'dataset_record';
var
     i : Smallint;
     r : string;
     a : array of string;
begin
     Result := '';
     if Length(ACampos) = 0 then
     begin
          SetLength(a, 2);
          a[0] := 'codigo';
          a[1] := 'descricao';
     end
     else
     begin
          SetLength(a, Length(ACampos));
          for i := Low(ACampos) to High(ACampos) do
              a[i] := ACampos[i];
     end;
     ADS.first;
     while not ADS.eof do
     begin
          r := '';
          for i := Low(a) to High(a) do
              r := r + trim(FH.SetXMLTag(a[i], ADS.FieldByName(a[i]).AsString));
          r := trim(FH.SetXMLTag(TAG_RECORD, r));
          Result := Result + r;
          ADS.next;
     end;
end;

//-------------------------------------------------------------------------------------------------------------------
function XMLParaDataset(ADS: TDataSet; const ACampos: array of string; const AXML: string; const ALimparDataSet: Boolean): Boolean;
const
     TAG_RECORD = 'dataset_record';
var
     i, tot : Smallint;
     vXml, vRecord, v : string;
     bAppend : Boolean;
     a : array of string;
begin
     Result := false;
     if Length(ACampos) = 0 then
     begin
          SetLength(a, 2);
          a[0] := 'codigo';
          a[1] := 'descricao';
     end
     else
     begin
          SetLength(a, Length(ACampos));
          for i := Low(ACampos) to High(ACampos) do
              a[i] := ACampos[i];
     end;

     if ADS is TClientDataSet then
     begin
          if not ADS.Active then
             TClientDataSet(ADS).CreateDataSet;
          if ALimparDataSet then
             TClientDataSet(ADS).EmptyDataSet;
     end;

     tot := 0;
     vXml := AXML;
     while FH.Contem(vXml, '<'+TAG_RECORD+'>') do
     begin
          bAppend := false;
          vRecord := FH.GetXMLTag(TAG_RECORD, vXml);
          if FH.StrOk(vRecord) then
          begin
               for i := Low(a) to High(a) do
               begin
                    if FH.XMLTagExiste(a[i], vRecord) then
                    begin
                         v := FH.GetXMLTag(a[i], vRecord);
                         if not bAppend then
                         begin
                              Inc(tot);
                              ADS.Append;
                              bAppend := True;
                         end;
                         ADS.FieldByName(a[i]).AsString := v;
                    end;
               end;
               if bAppend then
                  ADS.Post;
          end;
          vXml := FH.CopyPosMax(vXml, '</'+TAG_RECORD+'>');
     end;
     if ADS.Active then
        ADS.First;
     Result := tot > 0;
end;

//-------------------------------------------------------------------------------------------------------------------
function XMLTagExiste(const Tag, Texto: string): Boolean;
begin
     Result := false;
     if FH.PosStr('<' + Tag + '>', Texto) > 0 then
        Result := True;
end;

//-------------------------------------------------------------------------------------------------------------------
function StringParaBase64(const AValor: string): string;
begin
     Result := soap.EncdDecd.EncodeString(AValor) ;
end;

//-------------------------------------------------------------------------------------------------------------------
function Base64ParaString(const AValor: string): string;
begin
     Result := soap.EncdDecd.DecodeString(AValor) ;
end;

//-------------------------------------------------------------------------------------------------------------------
function SubAspas(const T: string): string;
begin
     Result := ReplaceText(T, FH.ASPAS_DUPLAS, FH.ASPAS_SIMPLES);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure SplitStr(const Str: string; const Delimiter: Char; var ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True;
   ListOfStrings.DelimitedText   := Str;
end;

//-------------------------------------------------------------------------------------------------------------------
function MultiStringReplace(const S: string; const OldPattern, NewPattern: array of string;
  Flags: TReplaceFlags): string;
var
  I: integer;
begin
  Result := S;
  for I := Low(OldPattern) to High(OldPattern) do
    Result := StringReplace(Result, OldPattern[I], NewPattern[I], Flags);
end;

//-------------------------------------------------------------------------------------------------------------------
function PreparaSql(const S: string): string;
begin
   Result := ReplaceText(FH.SubAspas( S ), '\n', FH.CRLF);
end;

//-------------------------------------------------------------------------------------------------------------------
procedure GirarBitmap90Graus(var Bitmap: TBitmap);
type
  TRGBArray = array[0..0] of TRGBTriple;
  pRGBArray = ^TRGBArray;
var
  J, I: integer;
  RI, RO: pRGBArray;
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  try
     bmp.Width := Bitmap.Height;
     bmp.Height := Bitmap.Width;
     bmp.PixelFormat := Bitmap.PixelFormat;
     for I := 0 to Bitmap.Width - 1 do
     begin
       RO := bmp.ScanLine[I];
       for J := 0 to Bitmap.Height - 1 do
       begin
         RI := Bitmap.ScanLine[J];
         RO[Bitmap.Height - J - 1] := RI[I];
       end;
     end;
     Bitmap.assign(bmp);
  finally
     bmp.free;
  end;
end;

//-------------------------------------------------------------------------------------------------------------------
function ValidaIdentificador(const Nome: string): Boolean;
var
    i, j: Integer;
    c: Char;
    inicial : Boolean;
begin
    Result := False;
    inicial := False;
    i := 1;
    j := 0;
    while i <= Length(Nome) do
    begin
        c := Nome[i];
        if (   (((Ord(c) < 65) or (Ord(c) > 90 ))) //A..Z
           and (((Ord(c) < 97) or (Ord(c) > 122))) //a..z
           and (((Ord(c) < 48) or (Ord(c) > 57 ))) //0..9
           and (c <> '_') ) then
        begin
            Exit;
        end;
        if ((((Ord(c) >= 65) and (Ord(c) <= 90 )))
        or (((Ord(c)  >= 97) and (Ord(c) <= 122)))) then
        begin
            j := j + 1;
            if i = 1 then
               inicial := True; // primeiro caracter é uma letra?
        end;
        i := i + 1;
    end;
    if j < 1 then // nenhuma letra entre A..Z/a..z?
       Exit;
    Result := inicial;
end;

end.
