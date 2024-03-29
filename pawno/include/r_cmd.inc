

#if defined _rcmd_included
	#endinput
#endif	
#define _rcmd_included
// =============================================

// ================== Natives ==================
/*
	native CallPlayerCommand(cmd_text[], playerid, params[0] = 0);
	native CallRCONCommand(cmd_text[], params[0] = 0);
*/
// =============================================

// ================= ��������� =================
const MAX_CMD_NAME = 14; // ������������ ��� �������
// =============================================

// =========== �������������� ������� ==========
static stock FixConsoleInput(source[]) /// by Romanius
{
	for(new i; source[i] != 0x0; i++)
	{
		switch(source[i])
		{
			case 0x80..0xAF: source[i] += 0x40;
			case 0xE0..0xEF: source[i] += 0x10;
			case 0xF0: 		 source[i] -= 0x48;
			case 0xF1: 		 source[i] -= 0x39;
			case 0xFC: 		 source[i] -= 0x43;
			default: 		 source[i] -= 0x0;
		}
	}
}
// =============================================

// ================ ��� ������ =================
public OnPlayerCommandText(playerid, cmdtext[])
{
    new i = 1, command[MAX_CMD_NAME char], cparams = 1; // ������� ���������� (��� i = 1 ������ ��� ������� ���������� � / (����))
	
	command{0} = 'p'; command{1} = '_'; // ��������� �������
	
	for( ; cmdtext[i] > 0x20; i++) command{i + 1} = tolower(cmdtext[i]); // ������� ��� ������� � ������ ��������
	
	if(funcidx(command) > 0) // �������� ���� �� ����� ������� � ����
	{
		while(cmdtext[i] == 0x20) i++; // ���������� �� ������� �������
		
		if(!cmdtext[i]) return CallLocalFunction(command, "isi", playerid, "\1", 0); // ���� ���������� ��� �� ������� ������� � ������� ����������
		else // ���� ��������(�) ����������(��)
		{
			for(new j = i; cmdtext[j] != 0x0; j++) if(cmdtext[j] == 0x20) cparams++; // ��������� ���������� ����������
			
			return CallLocalFunction(command, "isi", playerid, cmdtext[i], cparams); // ������� ���� �������
		}
	}
	else if(funcidx("rcmd_OnPlayerCommandText") > 0) return CallLocalFunction("rcmd_OnPlayerCommandText", "is", playerid, cmdtext); else return 0; // ���� ������� CallBack OnPlayerCommandText �� ������� ��� � ��������� ������ ��������� 0 (������ ������ "SERVER: Unkown command")
}

public OnRconCommand(cmd[])
{
	new i = 0, command[MAX_CMD_NAME char], cparams = 1; // ������� ����������
	
	command{0} = 'r'; command{1} = '_'; // ��������� �������
	
	for( ; cmd[i] > 0x20; i++) command{i + 2} = tolower(cmd[i]); // ������� ��� ������� � ������ ��������
	
	if(funcidx(command) > 0) // �������� ���� �� ����� ������� � ����
	{
		while(cmd[i] == 0x20) i++; // ���������� �� ������� �������
		
		if(!cmd[i]) return CallLocalFunction(command, "si", "\1", 0); // ���� ���������� ��� �� ������� ������� � ������� ����������
		else // ���� ��������(�) ����������(��)
		{
			for(new j = i; cmd[j] != 0x0; j++) if(cmd[j] == 0x20) cparams++; // ��������� ���������� ����������
			
			#if defined FIX_CONSOLE_INPUT
			  FixConsoleInput(cmd[i]); // ��������� ������� �����
			#endif
			
			return CallLocalFunction(command, "si", cmd[i], cparams); // ������� ���� �������
		}
	}
	else if(funcidx("rcmd_OnRconCommand") > 0) return CallLocalFunction("rcmd_OnRconCommand", "s", cmd); else return 0; // ���� ������� CallBack OnRconCommand �� ������� ��� � ��������� ������ ��������� 0 (������ ������ "Unkown command or varable")
}
// =============================================

// ===== ������� ��� ������ ������ �� ���� =====
stock CallPlayerCommand(cmd_text[], playerid, params[0] = 0)
{
	new command[MAX_CMD_NAME char], cparams = 1;  // ������� ����������
	
	command{0} = 'p'; command{1} = '_'; // ��������� �������
	
	for(new i = 0; cmd_text[i] != 0x0; i++) command{i + 2} = tolower(cmd_text[i]); // ������� ��� ������� � ������ ��������
	
	if(funcidx(command) > 0) // �������� ���� �� ����� ������� � ����
	{
		if(!params[0]) return CallLocalFunction(command, "isi", playerid, "\1", 0); // ���� ���������� ��� �� ������� ������� � ������� ����������
		else // ���� ��������(�) ����������(��)
		{
			for(new j = 0; params[j] != 0x0; j++) if(params[j] == 0x20) cparams++; // ��������� ���������� ����������
			
			return CallLocalFunction(command, "isi", playerid, params, cparams); // ������� ���� �������
		}
	}
	else return 0; // ���� ������� �� ������� ������ 0
}

stock CallRCONCommand(cmd_text[], params[0] = 0)
{
	new command[MAX_CMD_NAME char], cparams = 1;  // ������� ����������
	
	command{0} = 'r'; command{1} = '_'; // ��������� �������
	
	for(new i = 0; cmd_text[i] != 0x0; i++) command{i + 2} = tolower(cmd_text[i]); // ������� ��� ������� � ������ ��������
	
	if(funcidx(command) > 0) // �������� ���� �� ����� ������� � ����
	{
		if(!params[0]) return CallLocalFunction(command, "si", "\1", 0); // ���� ���������� ��� �� ������� ������� � ������� ����������
		else // ���� ��������(�) ����������(��)
		{
			for(new j = 0; params[j] != 0x0; j++) if(params[j] == 0x20) cparams++; // ��������� ���������� ����������
			
			return CallLocalFunction(command, "si", params, cparams); // ������� ���� �������
		}
	}
	else return 0; // ���� ������� �� ������� ������ 0
}
// =============================================

// ============= �������� �������� =============
#undef MAX_CMD_NAME
// =============================================

// ===== Forward'� ��� ���������� �������� =====
forward rcmd_OnPlayerCommandText(playerid, cmdtext[]);
forward rcmd_OnRconCommand(cmd[]);
// =============================================

// == ������� ��� �������� ������ ��� ������� ==
#define PLAYERCMD:%1(%2,%3,%4) forward p_%1(%2, %3, %4); \
							   public p_%1(%2, %3, %4)
							   
#define PCMD:%1(%2,%3,%4)      PLAYERCMD:%1(%2, %3, %4)
#define playercmd(%1,%2,%3,%4) PLAYERCMD:%1(%2, %3, %4)
#define pcmd(%1,%2,%3,%4)      PLAYERCMD:%1(%2, %3, %4)
// =============================================

// ===== ������� ��� �������� RCON ������ ======
#define RCONCMD:%1(%2,%3) forward r_%1(%2, %3); \
						  public r_%1(%2, %3)
					   
#define RCMD:%1(%2,%3)    RCONCMD:%1(%2, %3)
#define rconcmd(%1,%2,%3) RCONCMD:%1(%2, %3)
#define rcmd(%1,%2,%3)    RCONCMD:%1(%2, %3)
// =============================================

// ==== ������� ��� ������������ ��������� =====
#define OnPlayerCommandText rcmd_OnPlayerCommandText
#define OnRconCommand rcmd_OnRconCommand
// =============================================