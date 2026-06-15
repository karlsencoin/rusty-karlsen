# Karlsen v3.1.1 - Changelog

## DNS Seeder Address Update

### Changed in v3.1.1

**DNS Seeder Domains:**
- ❌ OLD: `mainnet-dnsseed-1.karlsencoin.com`
- ✅ NEW: `mainnet-dnsseed-1.karlsencoin.org`

- ❌ OLD: `mainnet-dnsseed-2.karlsencoin.com`
- ✅ NEW: `mainnet-dnsseed-2.karlsencoin.org`

### Why This Change?

The Karlsen Network is transitioning from `.com` to `.org` domains for DNS seeders. This aligns with the official DNS seeder infrastructure at:
- https://github.com/karlsen-network/dnsseeder

### Impact

**For Node Operators:**
- v3.1.1 nodes will query `.org` seeders
- Old v3.1.0 nodes will continue using `.com` seeders
- Both domains should point to the same infrastructure during transition

**For Network:**
- Improved branding consistency
- Aligns with community-driven nature (.org vs commercial .com)
- Future-proof for DNS seeder expansion

### Compatibility

✅ **Backward Compatible:** 
- Fallback peer mechanism ensures connectivity even if DNS seeders change
- 11 hardcoded fallback peers provide redundancy

⚠️ **DNS Configuration Required:**
If you're running DNS seeders, ensure both domains are configured:

```
mainnet-dnsseed-1.karlsencoin.com → [your IP]  (legacy support)
mainnet-dnsseed-1.karlsencoin.org → [your IP]  (new standard)
mainnet-dnsseed-2.karlsencoin.com → [your IP]  (legacy support)
mainnet-dnsseed-2.karlsencoin.org → [your IP]  (new standard)
```

### Files Modified

1. **consensus/core/src/config/params.rs**
   - MAINNET_PARAMS: `.com` → `.org`
   - TESTNET_PARAMS: `.com` → `.org`

2. **patches/01_params_fallback_peers.patch**
   - Updated DNS seeder references

### Testing

All binaries built from this source will:
1. Query `.org` DNS seeders first
2. Fall back to 11 hardcoded peers if DNS fails
3. Use peer discovery to find additional nodes

### Rollout Plan

**Phase 1 (Current):**
- v3.1.1 released with `.org` addresses
- Both `.com` and `.org` DNS servers operational

**Phase 2 (Future):**
- `.com` addresses redirect to `.org`
- Documentation updated across all platforms

**Phase 3 (Long-term):**
- `.com` addresses deprecated
- `.org` becomes canonical

---

**Version:** 3.1.1  
**Release Date:** 2026-04-12  
**Breaking Changes:** None (fallback peers provide redundancy)
