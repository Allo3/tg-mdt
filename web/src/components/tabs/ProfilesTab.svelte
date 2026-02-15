<script lang="ts">
    import { createEventDispatcher } from "svelte";
    import { profilesSearch } from "../../store/search";
    import type { Profile } from "../../store/stores";
    const dispatch = createEventDispatcher<{ select: Profile }>();

    // store moteur
    const { query, results, loading, error, onInput, search } = profilesSearch;

    function handleInput(e: Event) {
        onInput((e.target as HTMLInputElement).value);
    }

    function selectProfile(p: Profile) {
        dispatch("select", p);
    }
</script>

<div class="panel">
    <div class="toolbar">
        <input
                class="input"
                placeholder="Rechercher (prénom, nom, citizenid)…"
                bind:value={$query}
                on:input={handleInput}
                on:keydown={(e) => e.key === "Enter" && search()}
        />

        <button class="btn" on:click={() => search()} disabled={$loading}>
            {$loading ? "Rechercher" : "Rechercher"}
        </button>
    </div>

    {#if $error}
        <div class="hint danger">{error}</div>
    {/if}

    {#if $results.length === 0}
        <div class="hint muted">Aucun résultat.</div>
    {:else}
        <div class="list">
            {#each $results as p (p.citizenid)}
                <button
                        class="row"
                        type="button"
                        on:click|stopPropagation={() => selectProfile(p)}
                >
                    <div class="row-main">
                        <div class="row-title">{p.firstname} {p.lastname}</div>
                        <div class="row-sub">
                            <span class="chip">{p.citizenid}</span>
                            {#if p.job}<span class="chip muted">{p.job}</span>{/if}
                            {#if p.dob}<span class="chip muted">{p.dob}</span>{/if}
                            {#if p.phone}<span class="chip muted">{p.phone}</span>{/if}
                        </div>
                    </div>
                    <div class="row-cta">›</div>
                </button>
            {/each}
        </div>
    {/if}
</div>

<style>
    .panel { width: 100%; }

    .toolbar {
        display: flex;
        gap: 10px;
        align-items: center;
        margin-bottom: 12px;
    }

    .input{
        flex: 1;
        padding: 12px 14px;
        border-radius: 14px;
        border: 1px solid rgba(255,255,255,.15);
        background: rgba(255,255,255,.08);
        color: rgba(255,255,255,.92);
        outline: none;
    }
    .input::placeholder{ color: rgba(255,255,255,.5); }
    .input:focus{
        border-color: rgba(46,243,255,.45);
        box-shadow: 0 0 0 2px rgba(46,243,255,.15);
    }

    .btn{
        padding: 12px 14px;
        border-radius: 14px;
        border: 1px solid rgba(255,255,255,.15);
        background: rgba(255,255,255,.06);
        color: rgba(255,255,255,.92);
        cursor: pointer;
    }
    .btn:disabled{ opacity: .6; cursor: not-allowed; }

    .hint{
        padding: 12px;
        border-radius: 14px;
        background: rgba(255,255,255,.04);
        border: 1px solid rgba(255,255,255,.08);
    }
    .muted{ color: rgba(255,255,255,.62); }
    .danger{
        border-color: rgba(255,77,77,.35);
        background: rgba(255,77,77,.08);
    }

    .list{ display: flex; flex-direction: column; gap: 10px; }

    .row{
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        padding: 12px 12px;
        border-radius: 16px;
        color: white;
        border: 1px solid rgba(255,255,255,.10);
        background: rgba(255,255,255,.04);
        cursor: pointer;
        text-align: left;
    }
    .row:hover{
        border-color: rgba(46,243,255,.22);
        background: rgba(46,243,255,.06);
    }

    .row-title{ font-weight: 800; }
    .row-sub{
        margin-top: 6px;
        display: flex;
        gap: 8px;
        flex-wrap: wrap;
    }

    .chip{
        font-size: 12px;
        padding: 6px 8px;
        border-radius: 999px;
        border: 1px solid rgba(255,255,255,.10);
        background: rgba(0,0,0,.12);
    }

    .row-cta{ opacity: .65; font-size: 18px; }
</style>