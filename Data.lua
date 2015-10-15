--[[----------------------------------------------------------------------------
	Researcher
	Shows which recipes you can learn from research.
	Copyright (c) 2015 Phanx. All rights reserved.
	See the accompanying LICENSE.txt file for more information.
	https://github.com/Phanx/ResearchWhat
------------------------------------------------------------------------------]]
local _, private = ...
local data, dataByID = {}, {
	-- Alchemy
	[60893] = { -- Northrend Alchemy Research
		[53895] = false, -- Crazy Alchemist's Potion
		[60354] = false, -- Elixir of Accuracy
		[60365] = false, -- Elixir of Armor Piercing
		[60355] = false, -- Elixir of Deadly Strikes
		[60357] = false, -- Elixir of Expertise
		[60366] = false, -- Elixir of Lightning Speed
		[60356] = false, -- Elixir of Mighty Defense
		[56519] = false, -- Elixir of Mighty Mageblood
		[54220] = false, -- Elixir of Protection
		[62410] = false, -- Elixir of Water Walking
		[54221] = false, -- Potion of Speed
		[54222] = false, -- Potion of Wild Magic
		[53904] = false, -- Powerful Rejuvenation Potion
	},
	-- Inscription
	[165564] = { -- Moonglow Ink
		[57221] = "DEATHKNIGHT", -- Blood Boil
		[57224] = "DEATHKNIGHT", -- Foul Menagerie
		[57222] = "DEATHKNIGHT", -- Mind Freeze
		[56965] = "DRUID", -- Stars
		[64270] = "DRUID", -- Wild Growth
		[57003] = "HUNTER", -- Ice Trap
		[64253] = "HUNTER", -- Master's Call
		[58298] = "HUNTER", -- Stampede
		[64276] = "MAGE", -- Illusion
		[56983] = "MAGE", -- Rapid Displacement
		[56989] = "MAGE", -- Spellsteal
		[112454] = "MONK", -- Detox
		[112437] = "MONK", -- Nimble Brew
		[148260] = "PALADIN", -- Hand of Sacrifice
		[112265] = "PALADIN", -- Righteous Retreat
		[58314] = "PALADIN", -- the Mounted King
		[57185] = "PRIEST", -- Fear Ward
		[126687] = "PRIEST", -- Holy Resurrection
		[148278] = "PRIEST", -- Inspired Hymns
		[124460] = "PRIEST", -- Vampiric Embrace
		[64285] = "ROGUE", -- Killing Spree
		[57120] = "ROGUE", -- Recovery
		[148283] = "SHAMAN", -- Spirit Wolf
		[58332] = "SHAMAN", -- the Spectral Wolf
		[57251] = "SHAMAN", -- Water Shield
		[71102] = "WARLOCK", -- Eternal Resolve
		[57277] = "WARLOCK", -- Falling Meteor
		[57261] = "WARLOCK", -- Nightmares
		[64302] = "WARRIOR", -- Spell Reflection
		[64255] = "WARRIOR", -- Victorious Throw
	},
	[165304] = { -- Midnight Ink
		[64266] = "DEATHKNIGHT", -- Death Coil
		[57215] = "DEATHKNIGHT", -- Death's Embrace
		[148266] = "DEATHKNIGHT", -- the Skeleton
		[58297] = "HUNTER", -- Aspect of the Pack
		[57009] = "HUNTER", -- Tame Beast
		[148272] = "MAGE", -- Condensation
		[71101] = "MAGE", -- Counterspell
		[56980] = "MAGE", -- Splitting Ice
		[112450] = "MONK", -- Leer of the Ox
		[112444] = "MONK", -- Touch of Karma
		[148259] = "PALADIN", -- Divine Shield
		[112264] = "PALADIN", -- the Falling Avenger
		[58312] = "PALADIN", -- Winged Vengeance
		[124459] = "PRIEST", -- Mind Flay
		[57122] = "ROGUE", -- Feint
		[58326] = "ROGUE", -- Pick Pocket
		[57242] = "SHAMAN", -- Healing Stream Totem
		[148282] = "SHAMAN", -- Lingering Ancestors
		[57240] = "SHAMAN", -- Wind Shear
		[57271] = "WARLOCK", -- Shadow Bolt
		[94405] = "WARRIOR", -- Recklessness
	},
	[165456] = { -- Lion's Ink
		[148257] = "DEATHKNIGHT", -- Regenerative Magic
		[57225] = "DEATHKNIGHT", -- Strangulate
		[57209] = "DEATHKNIGHT", -- the Geist
		[58289] = "DRUID", -- Grace
		[148269] = "DRUID", -- One with Nature
		[57001] = "HUNTER", -- Disengage
		[57007] = "HUNTER", -- No Escape
		[58299] = "HUNTER", -- Revive Pet
		[148271] = "MAGE", -- Evaporation
		[112442] = "MONK", -- Life Cocoon
		[112440] = "MONK", -- Paralysis
		[124457] = "MONK", -- Transcendence
		[57037] = "PALADIN", -- Focused Wrath
		[57027] = "PALADIN", -- Holy Wrath
		[58322] = "PRIEST", -- Dark Archangel
		[57183] = "PRIEST", -- Purify
		[58323] = "ROGUE", -- Blurred Speed
		[148280] = "ROGUE", -- Improved Distraction
		[57132] = "ROGUE", -- Shiv
		[57238] = "SHAMAN", -- Fire Nova
		[148281] = "SHAMAN", -- Spirit Raptors
		[135561] = "WARLOCK", -- Gateway Attunement
		[57161] = "WARRIOR", -- Die by the Sword
		[123781] = "WARRIOR", -- the Blazing Trail
	},
	[165460] = { -- Jadefire Ink
		[148255] = "DEATHKNIGHT", -- Swift Death
		[148268] = "DRUID", -- Sprouting Mushroom
		[57000] = "HUNTER", -- Deterrence
		[58302] = "HUNTER", -- Fireworks
		[148270] = "MAGE", -- Unbound Elemental
		[124449] = "MONK", -- Guard
		[112468] = "MONK", -- Spirit Roll
		[124451] = "MONK", -- Zen Meditation
		[57036] = "PALADIN", -- Burden of Guilt
		[57022] = "PALADIN", -- Divine Protection
		[57200] = "PRIEST", -- Dispel Magic
		[127625] = "PRIEST", -- Lightwell
		[57119] = "ROGUE", -- Evasion
		[148279] = "ROGUE", -- Headhunting
		[148261] = "SHAMAN", -- Purging
		[182157] = "SHAMAN", -- Purify Spirit
		[58341] = "WARLOCK", -- Soulwell
		[112429] = "WARRIOR", -- Crow Feast
		[58345] = "WARRIOR", -- Gushing Wound
		[58347] = "WARRIOR", -- Mighty Victory
	},
	[165461] = { -- Celestial Ink
		[57220] = "DEATHKNIGHT", -- Enduring Infection
		[57219] = "DEATHKNIGHT", -- Icy Touch
		[59339] = "DEATHKNIGHT", -- Outbreak
		[64307] = "DRUID", -- Stampeding Roar
		[56950] = "DRUID", -- the Stag
		[56994] = "HUNTER", -- Aspects
		[57012] = "HUNTER", -- Mend Pet
		[64273] = "HUNTER", -- Tranquilizing Shot
		[58308] = "MAGE", -- Arcane Language
		[94000] = "MAGE", -- Inferno Blast
		[112463] = "MONK", -- Flying Serpent Kick
		[124456] = "MONK", -- Touch of Death
		[57034] = "PALADIN", -- Blessed Life
		[58316] = "PALADIN", -- Fire From the Heavens
		[148273] = "PALADIN", -- the Exorcist
		[64259] = "PRIEST", -- Binding Heal
		[64283] = "PRIEST", -- Mind Spike
		[107907] = "PRIEST", -- Shadow
		[92579] = "ROGUE", -- Blind
		[57114] = "ROGUE", -- Decoy
		[57126] = "ROGUE", -- Hemorrhage
		[57235] = "SHAMAN", -- Capacitor Totem
		[57252] = "SHAMAN", -- Cleansing Waters
		[57246] = "SHAMAN", -- the Lakestrider
		[57253] = "SHAMAN", -- Thunderstorm
		[58340] = "WARLOCK", -- Eye of Kilrogg
		[57276] = "WARLOCK", -- Unstable Affliction
		[57153] = "WARRIOR", -- Bloody Healing
		[57172] = "WARRIOR", -- Raging Wind
		[57157] = "WARRIOR", -- Rude Interruption
		[148292] = "WARRIOR", -- the Weaponmaster
	},
	[165463] = { -- Shimmering Ink
		[57210] = "DEATHKNIGHT", -- Icebound Fortitude
		[131152] = "DRUID", -- the Cheetah
		[148489] = "HUNTER", -- Enduring Deceit
		[126801] = "HUNTER", -- Fetch
		[57002] = "HUNTER", -- Freezing Trap
		[95710] = "MAGE", -- Rapid Teleportation
		[112466] = "MONK", -- Rising Tiger Kick
		[57023] = "PALADIN", -- Consecration
		[119481] = "PALADIN", -- the Battle Healer
		[57032] = "PALADIN", -- the Luminous Charger
		[57198] = "PRIEST", -- Scourge Imprisonment
		[58320] = "PRIEST", -- Shackle Undead
		[57129] = "ROGUE", -- Hemorrhaging Veins
		[58325] = "ROGUE", -- Pick Lock
		[148284] = "SHAMAN", -- Flaming Serpent
		[57236] = "SHAMAN", -- Purge
		[58333] = "SHAMAN", -- Totemic Encirclement
		[58336] = "WARLOCK", -- Unending Breath
		[57168] = "WARRIOR", -- Sweeping Strikes
		[148291] = "WARRIOR", -- the Watchful Eye
		[58346] = "WARRIOR", -- Unending Rage
	},
	[165464] = { -- Ethereal Ink
		[59340] = "DEATHKNIGHT", -- Corpse Explosion
		[58286] = "DRUID", -- Aquatic Form
		[95215] = "DRUID", -- the Treant
		[57005] = "HUNTER", -- Explosive Trap
		[148487] = "HUNTER", -- the Lean Pack
		[56991] = "MAGE", -- Arcane Power
		[56978] = "MAGE", -- Momentum
		[56990] = "MAGE", -- Remove Curse
		[112465] = "MONK", -- Jab
		[124452] = "MONK", -- Renewing Mist
		[124455] = "MONK", -- Surging Mist
		[182154] = "PALADIN", -- Cleanse
		[57033] = "PALADIN", -- Devotion Aura
		[58315] = "PALADIN", -- Seal of Blood
		[58318] = "PRIEST", -- Borrowed Time
		[148276] = "PRIEST", -- the Sha
		[57125] = "ROGUE", -- Gouge
		[58327] = "ROGUE", -- Safe Fall
		[58330] = "SHAMAN", -- Far Sight
		[148288] = "SHAMAN", -- Rain of Frogs
		[57265] = "WARLOCK", -- Health Funnel
		[57274] = "WARLOCK", -- Soulstone
		[58343] = "WARRIOR", -- Bloodcurdling Shout
		[148290] = "WARRIOR", -- the Subtle Defender
	},
	[165465] = { -- Ink of the Sea
		[57229] = "DEATHKNIGHT", -- Path of Frost
		[57230] = "DEATHKNIGHT", -- Resilient Grip
		[56952] = "DRUID", -- Rake
		[56948] = "DRUID", -- the Orca
		[94404] = "DRUID", -- the Predator
		[124442] = "HUNTER", -- Aspect of the Beast
		[56995] = "HUNTER", -- Camouflage
		[56972] = "MAGE", -- Arcane Explosion
		[112469] = "MONK", -- Fighting Pose
		[112457] = "MONK", -- Fortifying Brew
		[112464] = "MONK", -- Honor
		[58311] = "PALADIN", -- Contemplation
		[148275] = "PRIEST", -- Angels
		[126153] = "PRIEST", -- Confession
		[182156] = "PRIEST", -- Purification
		[58317] = "PRIEST", -- Shadow Ravens
		[58328] = "ROGUE", -- Poisons
		[148287] = "SHAMAN", -- Astral Fixation
		[58329] = "SHAMAN", -- Astral Recall
		[57270] = "WARLOCK", -- Havoc
		[58342] = "WARRIOR", -- Mystic Shout
		[148289] = "WARRIOR", -- the Raging Whirlwind
	},
	[165466] = { -- Blackfallow Ink
		[57228] = "DEATHKNIGHT", -- Death Gate
		[57217] = "DEATHKNIGHT", -- Horn of Winter
		[58296] = "DRUID", -- Charm Woodland Creature
		[58287] = "DRUID", -- the Chameleon
		[112462] = "MONK", -- Crackling Tiger Lightning
		[112461] = "MONK", -- Water Roll
		[57031] = "PALADIN", -- Divinity
		[122030] = "PALADIN", -- Mass Exorcism
		[57196] = "PRIEST", -- Psychic Scream
		[126800] = "PRIEST", -- Shadowy Friends
		[124466] = "PRIEST", -- the Heavens
		[64260] = "ROGUE", -- Disguise
		[58324] = "ROGUE", -- Distract
		[148286] = "SHAMAN", -- Elemental Familiars
		[57249] = "SHAMAN", -- Lava Lash
		[64262] = "SHAMAN", -- Shamanistic Rage
		[58339] = "WARLOCK", -- Enslave Demon
		[57257] = "WARLOCK", -- Hand of Gul'dan
		[58337] = "WARLOCK", -- Soul Consumption
		[112430] = "WARRIOR", -- Burning Anger
		[57154] = "WARRIOR", -- Hindering Strikes
		[68166] = "WARRIOR", -- Thunder Strike
	},
	[165467] = { -- Ink of Dreams
		[57226] = "DEATHKNIGHT", -- Pillar of Frost
		[57227] = "DEATHKNIGHT", -- Vampiric Blood
		[58288] = "DRUID", -- Blooming
		[64258] = "DRUID", -- Cyclone
		[182158] = "DRUID", -- the Solstice
		[58301] = "HUNTER", -- Lesser Proportion
		[56981] = "MAGE", -- Cone of Cold
		[58306] = "MAGE", -- Conjure Familiar
		[56979] = "MAGE", -- Ice Block
		[112458] = "MONK", -- Detoxing
		[182155] = "MONK", -- Flying Fists
		[112460] = "MONK", -- Zen Flight
		[112266] = "PALADIN", -- Bladed Judgment
		[148274] = "PALADIN", -- Pillar of Light
		[57194] = "PRIEST", -- Power Word: Shield
		[124461] = "PRIEST", -- Shadow Word: Death
		[126696] = "PRIEST", -- the Val'kyr
		[57123] = "ROGUE", -- Garrote
		[57133] = "ROGUE", -- Sprint
		[64261] = "SHAMAN", -- Deluge
		[59326] = "SHAMAN", -- Ghost Wolf
		[148285] = "SHAMAN", -- the Compy
		[57269] = "WARLOCK", -- Imp Swarm
		[64312] = "WARRIOR", -- Intimidating Shout
	},
	[167950] = { -- Warbinder's Ink
		[162805] = "DEATHKNIGHT", -- Absorb Magic
		[162806] = "DEATHKNIGHT", -- Ice Reaper
		[162808] = "DEATHKNIGHT", -- Empowerment
		[162810] = "DEATHKNIGHT", -- Raise Ally
		[162811] = "DEATHKNIGHT", -- Rune Tap
		[162812] = "DEATHKNIGHT", -- Runic Power
		[162813] = "DRUID", -- Astral Communion
		[162814] = "DRUID", -- Imbued Bark
		[162815] = "DRUID", -- Enchanted Bark
		[162817] = "DRUID", -- Ninth Life
		[162818] = "DRUID", -- Celestial Alignment
		[162819] = "DRUID", -- Nature's Cure
		[162820] = "DRUID", -- Maim
		[162821] = "DRUID", -- Savagery
		[162822] = "DRUID", -- Moonwarding
		[175186] = "DRUID", -- the Flapping Owl
		[178448] = "DRUID", -- the Shapemender
		[162823] = "DRUID", -- Travel
		[162824] = "HUNTER", -- Play Dead
		[162826] = "HUNTER", -- Quick Revival
		[162827] = "HUNTER", -- Snake Trap
		[162829] = "MAGE", -- Dragon's Breath
		[162830] = "MAGE", -- Regenerative Ice
		[162831] = "MONK", -- Expel Harm
		[162832] = "MONK", -- Floating Butterfly
		[162833] = "MONK", -- Flying Serpent
		[162834] = "MONK", -- Keg Smash
		[162835] = "MONK", -- Renewed Tea
		[162837] = "MONK", -- Freedom Roll
		[162838] = "MONK", -- Soothing Mist
		[162839] = "MONK", -- Zen Focus
		[162840] = "PALADIN", -- Ardent Defender
		[162841] = "PALADIN", -- Consecrator
		[162842] = "PALADIN", -- Divine Wrath
		[162843] = "PALADIN", -- Liberator
		[162844] = "PALADIN", -- Hand of Freedom
		[162846] = "PRIEST", -- Free Action
		[162847] = "PRIEST", -- Delayed Coalescence
		[162848] = "PRIEST", -- Guardian Spirit
		[162849] = "PRIEST", -- Restored Faith
		[162850] = "PRIEST", -- Miraculous Dispelling
		[162851] = "PRIEST", -- Inquisitor
		[162852] = "PRIEST", -- Silence
		[162853] = "PRIEST", -- Spirit of Redemption
		[162854] = "PRIEST", -- Shadow Magic
		[162855] = "ROGUE", -- Energy
		[162856] = "ROGUE", -- Elusiveness
		[162857] = "ROGUE", -- Energy Flows
		[162858] = "ROGUE", -- Disappearance
		[186239] = "SHAMAN", -- Ascendance
		[162859] = "SHAMAN", -- Ephemeral Spirits
		[162860] = "SHAMAN", -- Ghostly Speed
		[162861] = "SHAMAN", -- Grounding
		[162862] = "SHAMAN", -- Lava Spread
		[162863] = "SHAMAN", -- Reactive Shielding
		[162864] = "SHAMAN", -- Shamanistic Resolve
		[162865] = "SHAMAN", -- Shocks
		[162866] = "SHAMAN", -- Spiritwalker's Focus
		[162867] = "SHAMAN", -- Spiritwalker's Aegis
		[162869] = "WARLOCK", -- Dark Soul
		[162871] = "WARLOCK", -- Life Pact
		[162872] = "WARLOCK", -- Metamorphosis
		[162873] = "WARLOCK", -- Shadowflame
		[162874] = "WARLOCK", -- Soul Swap
		[162876] = "WARLOCK", -- Strengthened Resolve
		[162877] = "WARRIOR", -- Cleave
		[162878] = "WARRIOR", -- Drawn Sword
		[162879] = "WARRIOR", -- Heroic Leap
		[162880] = "WARRIOR", -- Mocking Banner
		[162881] = "WARRIOR", -- Raging Blow
		[162882] = "WARRIOR", -- Rallying Cry
		[162883] = "WARRIOR", -- Shattering Throw
		[162884] = "WARRIOR", -- Flawless Defense
	},
}
local fallbacks, fallbacksByID = {}, {
	-- Warbinder's Ink research can discover any lower-level research glyphs
	-- once all of its own glyphs have been discovered.
	[167950] = {165564,165304,165456,165460,165461,165463,165464,165465,165466,165467},
}
function private.GetData()
	if dataByID then
		for researchID, teaches in pairs(dataByID) do
			local researchName = GetSpellInfo(researchID)
			if researchName then
				data[researchName] = {}
				for skillID, class in pairs(teaches) do
					local skillName = GetSpellInfo(skillID)
					if skillName then
						data[researchName][skillName] = (class and "|c"..(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class].colorStr or "|cffffffff") .. skillName .. "|r"
						teaches[skillID] = nil
					end
				end
				if not next(teaches) then
					dataByID[researchID] = nil
				end
			end
		end
		if not next(dataByID) then
			dataByID = nil
		end
	end

	if fallbacksByID then
		print("Scanning fallbacks by ID")
		for masterID, others in pairs(fallbacksByID) do
			local masterName = GetSpellInfo(masterID)
			print("    Scanning master", masterID, masterName)
			if masterName then
				fallbacks[masterName] = fallbacks[masterName] or {}
				for i, researchID in pairs(others) do
					local researchName = GetSpellInfo(researchID)
					print("        Scanning slave", researchID, researchName)
					if researchName and data[researchName] then
						for spellName, coloredName in pairs(data[researchName]) do
							fallbacks[masterName][spellName] = coloredName
						end
					end
					if not (dataByID and dataByID[researchID]) then
						print("        Done with slave")
						others[i] = nil
					end
				end
				if not next(others) then
					print("    Done with master")
					fallbacksByID[masterID] = nil
				end
			end
		end
		if not next(fallbacksByID) then
			print("Done with fallbacks by ID")
			fallbacksByID = nil
		end
	end

	return data, fallbacks
end
