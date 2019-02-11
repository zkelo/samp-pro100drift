/*
 *	Copyright © 2012-2013 RyDeR`
 *	rCmd.inc (v0.2.0)
 *	
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
#if !defined sscanf
	#error you have to include the sscanf plugin in order to use it
#endif

#if defined _Included_rCmd
	#endinput
#else
	#define _Included_rCmd
#endif

#if !defined MAX_DYNAMIC_PARAMS
	#define MAX_DYNAMIC_PARAMS (16)
#endif

#include "DynamicParams.inc"

#if !defined MAX_FUNCTIONS
	#define MAX_FUNCTIONS (1024)
#endif

#if !defined MAX_SSCANF_FORMAT
	#define MAX_SSCANF_FORMAT (32)
#endif
	

stock
	bool: g_bInit,
	bool: g_bHasOPCR,
	bool: g_bHasOPCP,
	g_iNativeIdx,
	g_aszCmd[MAX_FUNCTIONS][MAX_SSCANF_FORMAT char]
;

#define rCmd[%0]->%1(%2) \
        cmd@%1();public cmd@%1(){new i=funcidx(#cmd_%1);if(-1!=i&&i<MAX_FUNCTIONS)strpack(g_aszCmd[i],#%0,sizeof(g_aszCmd[]));}cmd_%1(%2);public cmd_%1(%2)

public OnPlayerCommandText(playerid, cmdtext[]) {
	if(cmdtext[0] != '/' || cmdtext[0] == EOS) {
		return 0;
	}
	if(!g_bInit) {
		rCmd_Init();
	}
	if(g_bHasOPCR && !CallLocalFunction("OnPlayerCommandReceived", "is", playerid, cmdtext)) {
		return 1;
	}
	new
		iPos,
		szFunc[32]
	;
	while(cmdtext[++iPos] > ' ') {
		szFunc[iPos - 1] = tolower(cmdtext[iPos]);
	}
	format(szFunc, sizeof(szFunc), "cmd_%s", szFunc);
	
	new
		iFunc = funcidx(szFunc)
	;
	if(iFunc != -1 && iFunc < MAX_FUNCTIONS) {
		clearParams();
		
		if(g_aszCmd[iFunc][0] != EOS) {
			new
				szBuf[MAX_SSCANF_FORMAT],
				aiAddr[MAX_DYNAMIC_PARAMS][128]
			;
			strunpack(szBuf, g_aszCmd[iFunc]);

			pushParam(e_TYPE_STRING, cmdtext[iPos]);
			pushParam(e_TYPE_STRING, szBuf);
			
			for(new i = 0, iParams = getParamCount(szBuf); i < iParams; ++i) {
				pushParam(e_TYPE_BYREF, aiAddr[i][0]);
			}
			iFunc = !callNative(g_iNativeIdx, false);
			
			setParam(e_TYPE_MIXED, 0, playerid);
			setParam(e_TYPE_MIXED, 1, iFunc);
		} else {
			pushParam(e_TYPE_MIXED, playerid);
		}
		iFunc = callFunction(szFunc);
		
		if(g_bHasOPCP) {
			return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, true);
		}
	} else {
		if(g_bHasOPCP) {
			return CallLocalFunction("OnPlayerCommandPerformed", "isi", playerid, cmdtext, false);
		}
	}
	return 0;
}

static stock rCmd_Init() {
	static
		s_szFunc[32]
	;
	sscanf("1", "i", s_szFunc[0]); // Fix crash
	
	#emit CONST.PRI sscanf
	#emit STOR.PRI g_iNativeIdx
	
	for(new i = 0; i < MAX_FUNCTIONS; ++i) {
		if(!getPublicNameByIndex(i, s_szFunc, sizeof(s_szFunc))) {
			continue;
		}
		if(strfind(s_szFunc, "cmd@") != -1) {
			CallLocalFunction(s_szFunc, "");
		}
	}
	if(!g_bHasOPCR) {
		g_bHasOPCR = !!(funcidx("OnPlayerCommandReceived") != -1);
	}
	if(!g_bHasOPCP) {
		g_bHasOPCP = !!(funcidx("OnPlayerCommandPerformed") != -1);
	}
	g_bInit = true;
}

static stock getPublicNameByIndex(const iIdx, szName[], const iSize = sizeof(szName)) {
	static
		s_iBase,
		s_iPublics,
		s_iNatives,
		s_iCount
	;
	if(!s_iBase) {
		#emit LCTRL 1
		#emit NEG
		#emit STOR.PRI s_iBase
	}
	if(!s_iPublics) {
		new
			iAddr
		;
		#emit LOAD.PRI s_iBase
		#emit ADD.C 32
		#emit STOR.S.PRI iAddr
		#emit LREF.S.PRI iAddr	
		#emit LOAD.S.ALT iAddr
		#emit ADD
		#emit CONST.ALT 32
		#emit SUB	
		#emit STOR.PRI s_iPublics
	}
	if(!s_iNatives) {
		new
			iAddr
		;
		#emit LOAD.PRI s_iBase
		#emit ADD.C 36
		#emit STOR.S.PRI iAddr
		#emit LREF.S.PRI iAddr	
		#emit LOAD.S.ALT iAddr
		#emit ADD
		#emit CONST.ALT 36
		#emit SUB
		#emit STOR.PRI s_iNatives
	}
	if(!s_iCount) {
		s_iCount = ((s_iNatives - s_iPublics) >>> 3);
	}
	if(iIdx < s_iCount) {
		new
			iPos = (iIdx << 3) + s_iPublics + 4,
			iCh,
			i
		;
		#emit LREF.S.PRI iPos
		#emit LOAD.ALT s_iBase
		#emit ADD
		#emit STOR.S.PRI iPos

		do {
			#emit LREF.S.PRI iPos
			#emit STOR.S.PRI iCh

			szName[i] = iCh & 0xFF;
				
			iPos++;
		} while(szName[i++] != EOS && i <= iSize);
		szName[i] = EOS;
		
		return 1;
	}
	return 0;
}

static stock getParamCount(szFormat[]) {
	new
		iParams
	;
	for(new i = 0, j = strlen(szFormat); i < j; ++i) {
		switch(szFormat[i]) {
			case 'l', 'k', 'b', 'n', 'c', 'i', 'd', 'h', 'o', 'f', 'g', 'u', 'q', 'r': {
				iParams++;
			}
			case 'L', 'K', 'B', 'N', 'C', 'I', 'D', 'H', 'O', 'F', 'G', 'U', 'Q', 'R', 'E': {
				i = findNext(szFormat, "(", ")", i);
				iParams++;
			}
			case 'Z', 'z', 'S', 's', 'A', 'a': {
				i = findNext(szFormat, "[", "]", i);
				iParams++;
			}
			case 'e': {
				i = findNext(szFormat, "<", ">", i);
				iParams++;
			}
		}
	}
	return iParams;
}

static stock findNext(szFormat[], szOpen[], szClosed[], iIdx) {
	new
		iFound = strfind(szFormat, szOpen, false, iIdx);
	
	if(iFound != -1) {
		iIdx = iFound;
		iFound = 0;
		
		while(szFormat[iIdx] != EOS) {
			if(szFormat[iIdx] == szOpen[0]) {
				iFound++;
			} else if(szFormat[iIdx] == szClosed[0]) {
				iFound--;
			}
			if(!iFound) {
				break;
			}
			iIdx++;
		}
	}
	return iIdx;
}

forward OnPlayerCommandReceived(playerid, cmdtext[]);
forward OnPlayerCommandPerformed(playerid, cmdtext[], success);

#if defined _ALS_OnPlayerCommandText
	#undef OnPlayerCommandText
#else
	#define _ALS_OnPlayerCommandText
#endif

#define OnPlayerCommandText rCmd_OnPlayerCommandText

forward rCmd_OnPlayerCommandText(playerid, cmdtext[]);