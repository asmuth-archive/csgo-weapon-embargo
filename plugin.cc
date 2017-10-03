#include "plugin.h"
#include "hl2sdk/public/eiface.h"
#include "hl2sdk/public/server_class.h"

static const char kPluginDescription[] = "CS:GO Weapon Restrict Plugin";

const char* Plugin::GetPluginDescription() {
  return kPluginDescription;
}

bool Plugin::Load(
    CreateInterfaceFn interfaceFactory,
    CreateInterfaceFn gameServerFactory) {
  Msg("Loading Plugin: %s\n", kPluginDescription);
  return true;
}

void Plugin::Unload() {}

void Plugin::Pause() {}

void Plugin::UnPause() {}

void Plugin::LevelInit(char const* pMapName) {}

void Plugin::ServerActivate(edict_t* pEdictList, int edictCount, int clientMax) {}

void Plugin::GameFrame(bool simulating) {}

void Plugin::LevelShutdown() {}

void Plugin::OnQueryCvarValueFinished(
    QueryCvarCookie_t iCookie,
    edict_t* pPlayerEntity,
    EQueryCvarValueStatus eStatus,
    const char* pCvarName,
    const char* pCvarValue) {}

void Plugin::OnEdictAllocated(edict_t* edict) {}

void Plugin::OnEdictFreed(const edict_t* edict) {}

PLUGIN_RESULT Plugin::ClientConnect(
    bool* bAllowConnect,
    edict_t* pEntity,
    const char* pszName,
    const char* pszAddress,
    char* reject,
    int maxrejectlen) {
  return PLUGIN_CONTINUE;
}

void Plugin::ClientFullyConnect(edict_t* pEntity) {}

void Plugin::ClientPutInServer(edict_t* entity, const char* playername) {}

void Plugin::ClientActive(edict_t* pEntity) {}

void Plugin::ClientDisconnect(edict_t* pEntity) {}

void Plugin::SetCommandClient(int index) {}

void Plugin::ClientSettingsChanged(edict_t* pEdict){}

PLUGIN_RESULT Plugin::ClientCommand(edict_t* pEntity, const CCommand& args) {
  if (strcmp(args[0], "buy") == 0) {
    if (strcmp(args[1], "awp") == 0) {
      return PLUGIN_STOP;
    }
  }

  return PLUGIN_CONTINUE;
}

PLUGIN_RESULT Plugin::NetworkIDValidated(
    const char* pszUserName,
    const char* pszNetworkID) {
  return PLUGIN_CONTINUE;
}

bool Plugin::BNetworkCryptKeyCheckRequired(
    uint32 unFromIP,
    uint16 usFromPort,
    uint32 unAccountIdProvidedByClient,
    bool bClientWantsToUseCryptKey) {
  return false;
}

bool Plugin::BNetworkCryptKeyValidate(
    uint32 unFromIP,
    uint16 usFromPort,
    uint32 unAccountIdProvidedByClient,
    int nEncryptionKeyIndexFromClient,
    int numEncryptedBytesFromClient,
    byte* pbEncryptedBufferFromClient,
    byte* pbPlainTextKeyForNetchan) {
  return false;
}

