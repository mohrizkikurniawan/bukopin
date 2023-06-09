*-----------------------------------------------------------------------------
* <Rating>1263</Rating>
* 07:12:44 31 JAN 2018 * 04:01:37 21 JUL 2017
* JFT/t24r11 * JFT/t24r11
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.ORK.CUS.ONBOARD
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 201707021
* Description        : Input routine ORK data Customer Onboarding
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.ORK.DATA
    $INSERT I_F.ATI.TH.EC.USERNAME

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.EC.USERNAME = "F.ATI.TH.EC.USERNAME"
    CALL OPF(FN.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME)

    GOSUB MAPPING.T24.LEGACY

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ORK.DATA.FIELD.LIST = R.NEW(ORK.DATA.FIELD)
    Y.ORK.DATA.VALUE.LIST = R.NEW(ORK.DATA.VALUE)

*-Check customer already onboarding or not------------------------------------
    FIND "EMAIL" IN Y.ORK.DATA.FIELD.LIST SETTING POSF, POSV, POSS THEN
        Y.EMAIL.VALUE = R.NEW(ORK.DATA.VALUE)<1, POSV>

        CALL F.READ(FN.ATI.TH.EC.USERNAME, Y.EMAIL.VALUE, R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, ERR.ATI.TH.EC.USERNAME)
        Y.CUST.ONBOARD.ORK = R.ATI.TH.EC.USERNAME<EC.USER.CUST.ONBOARD.ORK>

        IF Y.CUST.ONBOARD.ORK THEN
            AF    = ""
            ETEXT = "EB-ATI.CUST.ALREADY.ONBOARD"
            
			CALL STORE.END.ERROR
            RETURN
        END
    END

*-Convert data from legacy----------------------------------------------------
    FIND "CIF.LEGACY.ID" IN Y.ORK.DATA.FIELD.LIST SETTING POSF, POSV, POSS THEN
        Y.CIF.LEGACY.ID.VALUE = R.NEW(ORK.DATA.VALUE)<1, POSV>

        IF Y.CIF.LEGACY.ID.VALUE THEN
*-BUSSINES TYPE--------------------------------------------------------------
            FIND "BUSINESS.TYPE" IN Y.ORK.DATA.FIELD.LIST SETTING POSF1, POSV1, POSS1 THEN
                Y.BUSINESS.TYPE.VALUE = Y.ORK.DATA.VALUE.LIST<1, POSV1>

                IF Y.BUSINESS.TYPE.VALUE THEN
                    FIND Y.BUSINESS.TYPE.VALUE IN Y.BUSINESS.TYPE.LEGACY.LIST SETTING POSF2, POSV2, POSS2 THEN
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = Y.BUSINESS.TYPE.T24.LIST<POSF2>
                    END
                    ELSE
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = "33"        ;*Ibu rumah tangga
                    END
                END
                ELSE
                    R.NEW(ORK.DATA.VALUE)<1, POSV1> = "33"  ;*Ibu rumah tangga
                END
            END

*-PURPOSE ACCOUNT OPEN--------------------------------------------------------
            FIND "PURPOSE.ACCOUNT.OPEN" IN Y.ORK.DATA.FIELD.LIST SETTING POSF1, POSV1, POSS1 THEN
                Y.PURPOSE.ACCOUNT.OPEN.VALUE = Y.ORK.DATA.VALUE.LIST<1, POSV1>

                IF Y.PURPOSE.ACCOUNT.OPEN.VALUE THEN
                    FIND Y.PURPOSE.ACCOUNT.OPEN.VALUE IN Y.PURPOSE.ACCOUNT.OPEN.LEGACY.LIST SETTING POSF2, POSV2, POSS2 THEN
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = Y.PURPOSE.ACCOUNT.OPEN.T24.LIST<POSF2>
                    END
                    ELSE
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = "4"         ;*LAIN-LAIN
                    END
                END
                ELSE
                    R.NEW(ORK.DATA.VALUE)<1, POSV1> = "4"   ;*LAIN-LAIN
                END
            END

*-SOURCE OF FUND--------------------------------------------------------------
            FIND "SOURCE.OF.FUND" IN Y.ORK.DATA.FIELD.LIST SETTING POSF1, POSV1, POSS1 THEN
                Y.SOURCE.OF.FUND.VALUE = Y.ORK.DATA.VALUE.LIST<1, POSV1>

                IF Y.SOURCE.OF.FUND.VALUE THEN
                    FIND Y.SOURCE.OF.FUND.VALUE IN Y.SOURCE.OF.FUND.LEGACY.LIST SETTING POSF2, POSV2, POSS2 THEN
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = Y.SOURCE.OF.FUND.T24.LIST<POSF2>
                    END
                    ELSE
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = "7"         ;*Lainnya
                    END
                END
                ELSE
                    R.NEW(ORK.DATA.VALUE)<1, POSV1> = "7"   ;*Lainnya
                END
            END

*-RANGE OF FUND---------------------------------------------------------------
            FIND "RANGE.OF.FUND" IN Y.ORK.DATA.FIELD.LIST SETTING POSF1, POSV1, POSS1 THEN
                Y.RANGE.OF.FUND.VALUE = Y.ORK.DATA.VALUE.LIST<1, POSV1>

                IF Y.RANGE.OF.FUND.VALUE THEN
                    FIND Y.RANGE.OF.FUND.VALUE IN Y.RANGE.OF.FUND.LEGACY.LIST SETTING POSF2, POSV2, POSS2 THEN
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = Y.RANGE.OF.FUND.T24.LIST<POSF2>
                    END
                    ELSE
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = "7"         ;*Lainnya
                    END
                END
                ELSE
                    R.NEW(ORK.DATA.VALUE)<1, POSV1> = "7"   ;*Lainnya
                END
            END


*-RANGE OF EXPENSE------------------------------------------------------------
            FIND "RANGE.OF.EXPENSE" IN Y.ORK.DATA.FIELD.LIST SETTING POSF1, POSV1, POSS1 THEN
                Y.RANGE.OF.EXPENSE.VALUE = Y.ORK.DATA.VALUE.LIST<1, POSV1>

                IF Y.RANGE.OF.EXPENSE.VALUE THEN
                    FIND Y.RANGE.OF.EXPENSE.VALUE IN Y.RANGE.OF.EXPENSE.LEGACY.LIST SETTING POSF2, POSV2, POSS2 THEN
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = Y.RANGE.OF.EXPENSE.T24.LIST<POSF2>
                    END
                    ELSE
                        R.NEW(ORK.DATA.VALUE)<1, POSV1> = "7"         ;*Lainnya
                    END
                END
                ELSE
                    R.NEW(ORK.DATA.VALUE)<1, POSV1> = "7"   ;*Lainnya
                END
            END
        END
    END

    RETURN

*-----------------------------------------------------------------------------
MAPPING.T24.LEGACY:
*-----------------------------------------------------------------------------
*-BUSINESS TYPE---------------------------------------------------------------
    Y.BUSINESS.TYPE.T24.LIST<1>  = "1"  ;*Bidang Usaha Pertambangan
    Y.BUSINESS.TYPE.T24.LIST<2>  = "2"  ;*Industri Eletronika
    Y.BUSINESS.TYPE.T24.LIST<3>  = "3"  ;*Industri makanan/minuman
    Y.BUSINESS.TYPE.T24.LIST<4>  = "4"  ;*Industri Rokok
    Y.BUSINESS.TYPE.T24.LIST<5>  = "5"  ;*Jasa konstruksi
    Y.BUSINESS.TYPE.T24.LIST<6>  = "6"  ;*Banking
    Y.BUSINESS.TYPE.T24.LIST<7>  = "7"  ;*Conversion
    Y.BUSINESS.TYPE.T24.LIST<8>  = "8"  ;*Education
    Y.BUSINESS.TYPE.T24.LIST<9>  = "9"  ;*Entertainment
    Y.BUSINESS.TYPE.T24.LIST<10> = "10" ;*Dana pensiun & Pembiayaan / Finance
    Y.BUSINESS.TYPE.T24.LIST<11> = "11" ;*Government
    Y.BUSINESS.TYPE.T24.LIST<12> = "12" ;*Hospital
    Y.BUSINESS.TYPE.T24.LIST<13> = "13" ;*Hotel
    Y.BUSINESS.TYPE.T24.LIST<14> = "14" ;*Industry
    Y.BUSINESS.TYPE.T24.LIST<15> = "15" ;*Insurance
    Y.BUSINESS.TYPE.T24.LIST<16> = "16" ;*Jasa
    Y.BUSINESS.TYPE.T24.LIST<17> = "17" ;*Manufacturing
    Y.BUSINESS.TYPE.T24.LIST<18> = "18" ;*Tourism
    Y.BUSINESS.TYPE.T24.LIST<19> = "19" ;*Agen perjalanan / trading
    Y.BUSINESS.TYPE.T24.LIST<20> = "20" ;*Transportation
    Y.BUSINESS.TYPE.T24.LIST<21> = "21" ;*Ternak Ayam
    Y.BUSINESS.TYPE.T24.LIST<22> = "22" ;*Money Changer
    Y.BUSINESS.TYPE.T24.LIST<23> = "23" ;*Jasa Pengiriman uang
    Y.BUSINESS.TYPE.T24.LIST<24> = "24" ;*Akuntan, Pengacara, Notaris
    Y.BUSINESS.TYPE.T24.LIST<25> = "25" ;*Surveyor & Agen Real Estate
    Y.BUSINESS.TYPE.T24.LIST<26> = "26" ;*Pedagang Logam Mulia
    Y.BUSINESS.TYPE.T24.LIST<27> = "27" ;*Penjual Barang Antik & Mewah
    Y.BUSINESS.TYPE.T24.LIST<28> = "28" ;*Lembaga Swadaya masyarakat
    Y.BUSINESS.TYPE.T24.LIST<29> = "29" ;*partai Politik
    Y.BUSINESS.TYPE.T24.LIST<30> = "30" ;*Perusahaan Asing
    Y.BUSINESS.TYPE.T24.LIST<31> = "31" ;*Kasino / Organisasi Permainan
    Y.BUSINESS.TYPE.T24.LIST<32> = "32" ;*Pelajar/ Mahasiswa
    Y.BUSINESS.TYPE.T24.LIST<33> = "33" ;*Ibu rumah tangga

    Y.BUSINESS.TYPE.LEGACY.LIST<1>  = "1"         ;*Bidang Usaha Pertambangan
    Y.BUSINESS.TYPE.LEGACY.LIST<2>  = "2"         ;*Industri Eletronika
    Y.BUSINESS.TYPE.LEGACY.LIST<3>  = "3"         ;*Industri makanan/minuman
    Y.BUSINESS.TYPE.LEGACY.LIST<4>  = "4"         ;*Industri Rokok
    Y.BUSINESS.TYPE.LEGACY.LIST<5>  = "5"         ;*Jasa konstruksi
    Y.BUSINESS.TYPE.LEGACY.LIST<6>  = "6"         ;*Banking
    Y.BUSINESS.TYPE.LEGACY.LIST<7>  = "7"         ;*Conversion
    Y.BUSINESS.TYPE.LEGACY.LIST<8>  = "8"         ;*Education
    Y.BUSINESS.TYPE.LEGACY.LIST<9>  = "9"         ;*Entertainment
    Y.BUSINESS.TYPE.LEGACY.LIST<10> = "10"        ;*Dana pensiun & Pembiayaan / Finance
    Y.BUSINESS.TYPE.LEGACY.LIST<11> = "11"        ;*Government
    Y.BUSINESS.TYPE.LEGACY.LIST<12> = "12"        ;*Hospital
    Y.BUSINESS.TYPE.LEGACY.LIST<13> = "13"        ;*Hotel
    Y.BUSINESS.TYPE.LEGACY.LIST<14> = "14"        ;*Industry
    Y.BUSINESS.TYPE.LEGACY.LIST<15> = "15"        ;*Insurance
    Y.BUSINESS.TYPE.LEGACY.LIST<16> = "16"        ;*Jasa
    Y.BUSINESS.TYPE.LEGACY.LIST<17> = "17"        ;*Manufacturing
    Y.BUSINESS.TYPE.LEGACY.LIST<18> = "18"        ;*Tourism
    Y.BUSINESS.TYPE.LEGACY.LIST<19> = "19"        ;*Agen perjalanan / trading
    Y.BUSINESS.TYPE.LEGACY.LIST<20> = "20"        ;*Transportation
    Y.BUSINESS.TYPE.LEGACY.LIST<21> = "21"        ;*Ternak Ayam
    Y.BUSINESS.TYPE.LEGACY.LIST<22> = "22"        ;*Money Changer
    Y.BUSINESS.TYPE.LEGACY.LIST<23> = "23"        ;*Jasa Pengiriman uang
    Y.BUSINESS.TYPE.LEGACY.LIST<24> = "24"        ;*Akuntan, Pengacara, Notaris
    Y.BUSINESS.TYPE.LEGACY.LIST<25> = "25"        ;*Surveyor & Agen Real Estate
    Y.BUSINESS.TYPE.LEGACY.LIST<26> = "26"        ;*Pedagang Logam Mulia
    Y.BUSINESS.TYPE.LEGACY.LIST<27> = "27"        ;*Penjual Barang Antik & Mewah
    Y.BUSINESS.TYPE.LEGACY.LIST<28> = "28"        ;*Lembaga Swadaya masyarakat
    Y.BUSINESS.TYPE.LEGACY.LIST<29> = "29"        ;*partai Politik
    Y.BUSINESS.TYPE.LEGACY.LIST<30> = "30"        ;*Perusahaan Asing
    Y.BUSINESS.TYPE.LEGACY.LIST<31> = "31"        ;*Kasino / Organisasi Permainan
    Y.BUSINESS.TYPE.LEGACY.LIST<32> = "32"        ;*Pelajar/ Mahasiswa
    Y.BUSINESS.TYPE.LEGACY.LIST<33> = "33"        ;*Ibu rumah tangga

*-PURPOSE ACCOUNT OPEN--------------------------------------------------------
    Y.PURPOSE.ACCOUNT.OPEN.T24.LIST<1> = "1"      ;*INVESTASI
    Y.PURPOSE.ACCOUNT.OPEN.T24.LIST<2> = "2"      ;*OPERASIONAL
    Y.PURPOSE.ACCOUNT.OPEN.T24.LIST<3> = "3"      ;*GAJI
    Y.PURPOSE.ACCOUNT.OPEN.T24.LIST<4> = "4"      ;*LAIN-LAIN

    Y.PURPOSE.ACCOUNT.OPEN.LEGACY.LIST<1> = "1"   ;*INVESTASI
    Y.PURPOSE.ACCOUNT.OPEN.LEGACY.LIST<2> = "2"   ;*OPERASIONAL
    Y.PURPOSE.ACCOUNT.OPEN.LEGACY.LIST<3> = "3"   ;*GAJI
    Y.PURPOSE.ACCOUNT.OPEN.LEGACY.LIST<4> = "4"   ;*LAIN - LAIN

*-SOURCE OF FUND--------------------------------------------------------------
    Y.SOURCE.OF.FUND.T24.LIST<1> = "1"  ;*Gaji (per bulan)
    Y.SOURCE.OF.FUND.T24.LIST<2> = "2"  ;*Warisan/Hibah/Hadiah (per bulan)
    Y.SOURCE.OF.FUND.T24.LIST<3> = "3"  ;*Usaha Sampingan (per bulan)
    Y.SOURCE.OF.FUND.T24.LIST<4> = "4"  ;*Omzet Usaha (per bulan)
    Y.SOURCE.OF.FUND.T24.LIST<5> = "5"  ;*Usaha Group Perusahaan (per bulan)
    Y.SOURCE.OF.FUND.T24.LIST<6> = "6"  ;*Usaha Anak Perusahaan (per bulan)
    Y.SOURCE.OF.FUND.T24.LIST<7> = "7"  ;*Lainnya
    Y.SOURCE.OF.FUND.T24.LIST<8> = "8"  ;*Penjualan Aset

    Y.SOURCE.OF.FUND.LEGACY.LIST<1> = "3"         ;*GAJI
    Y.SOURCE.OF.FUND.LEGACY.LIST<2> = ""          ;*
    Y.SOURCE.OF.FUND.LEGACY.LIST<3> = "1"         ;*HASIL USAHA
    Y.SOURCE.OF.FUND.LEGACY.LIST<4> = "2"         ;*OPS USAHA
    Y.SOURCE.OF.FUND.LEGACY.LIST<5> = ""          ;*
    Y.SOURCE.OF.FUND.LEGACY.LIST<6> = ""          ;*
    Y.SOURCE.OF.FUND.LEGACY.LIST<7> = "9"         ;*LAINNYA
    Y.SOURCE.OF.FUND.LEGACY.LIST<8> = ""          ;*

*-RANGE OF FUND---------------------------------------------------------------
    Y.RANGE.OF.FUND.T24.LIST<1> = "1"   ;*5 JT s/d < 10 JT
    Y.RANGE.OF.FUND.T24.LIST<4> = "4"   ;*10 JT s/d < 25 JT
    Y.RANGE.OF.FUND.T24.LIST<5> = "5"   ;*25 JT s/d < 50 JT
    Y.RANGE.OF.FUND.T24.LIST<6> = "6"   ;*50 JT s/d < 100 JT
    Y.RANGE.OF.FUND.T24.LIST<7> = "7"   ;*100 JT ke atas

    Y.RANGE.OF.FUND.LEGACY.LIST<1> = "1"          ;*< 1 JT
    Y.RANGE.OF.FUND.LEGACY.LIST<2> = "2"          ;*1 JT s/d < 5 JT
    Y.RANGE.OF.FUND.LEGACY.LIST<3> = "3"          ;*5 JT s/d < 10 JT
    Y.RANGE.OF.FUND.LEGACY.LIST<4> = "4"          ;*10 JT s/d < 25 JT
    Y.RANGE.OF.FUND.LEGACY.LIST<5> = "5"          ;*25 JT s/d < 50 JT
    Y.RANGE.OF.FUND.LEGACY.LIST<6> = "6"          ;*50 JT s/d < 100 JT
    Y.RANGE.OF.FUND.LEGACY.LIST<7> = "7"          ;*100 JT ke atas

*-RANGE OF EXPENSE------------------------------------------------------------
    Y.RANGE.OF.EXPENSE.T24.LIST<1> = "1"          ;*< 1 JT
    Y.RANGE.OF.EXPENSE.T24.LIST<2> = "2"          ;*1 JT s/d < 5 JT
    Y.RANGE.OF.EXPENSE.T24.LIST<3> = "3"          ;*5 JT s/d < 10 JT
    Y.RANGE.OF.EXPENSE.T24.LIST<4> = "4"          ;*10 JT s/d < 25 JT
    Y.RANGE.OF.EXPENSE.T24.LIST<5> = "5"          ;*25 JT s/d < 50 JT
    Y.RANGE.OF.EXPENSE.T24.LIST<6> = "6"          ;*50 JT s/d < 100 JT
    Y.RANGE.OF.EXPENSE.T24.LIST<7> = "7"          ;*100 JT ke atas

    Y.RANGE.OF.EXPENSE.LEGACY.LIST<1> = "1"       ;*< 1 JT
    Y.RANGE.OF.EXPENSE.LEGACY.LIST<2> = "2"       ;*1 JT s/d < 5 JT
    Y.RANGE.OF.EXPENSE.LEGACY.LIST<3> = "3"       ;*5 JT s/d < 10 JT
    Y.RANGE.OF.EXPENSE.LEGACY.LIST<4> = "4"       ;*10 JT s/d < 25 JT
    Y.RANGE.OF.EXPENSE.LEGACY.LIST<5> = "5"       ;*25 JT s/d < 50 JT
    Y.RANGE.OF.EXPENSE.LEGACY.LIST<6> = "6"       ;*50 JT s/d < 100 JT
    Y.RANGE.OF.EXPENSE.LEGACY.LIST<7> = "7"       ;*100 JT ke atas

    RETURN
*-----------------------------------------------------------------------------
END

