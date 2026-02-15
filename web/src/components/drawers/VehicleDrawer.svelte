<script lang="ts">
    import type { Vehicle } from "../../store/stores";

    export let vehicle: Vehicle | null = null;
    export let onClose: () => void;
    export let onOwner: (citizenid: string) => void;
</script>

{#if vehicle}
    <aside class="drawer">
        <div class="drawer-top">
            <div class="title">Véhicule</div>
            <button class="x" on:click={onClose}>✕</button>
        </div>

        <div class="card">
            <div class="name">{vehicle.plate}</div>

            <div class="meta">
                {#if vehicle.model}
                    <span class="chip">{vehicle.model}</span>
                {/if}

                {#if vehicle.state !== undefined}
                    <span class="chip muted">state: {vehicle.state}</span>
                {/if}
            </div>
        </div>

        <div class="actions">
            <button
                    class="btn"
                    disabled={!vehicle.owner}
                    on:click={() => vehicle?.owner && onOwner(vehicle.owner)}
            >
                Voir propriétaire
            </button>
        </div>
    </aside>
{/if}

<style>
    .drawer{
        height: 100%;
        border-left: 1px solid rgba(255,255,255,.10);
        background: rgba(0,0,0,.12);
        padding: 12px;
        overflow: auto;
    }
    .drawer-top{
        display:flex; align-items:center; justify-content:space-between;
        margin-bottom: 10px;
    }
    .title{ font-weight: 800; letter-spacing: .2px; }
    .x{
        width: 34px; height: 34px;
        border-radius: 12px;
        border: 1px solid rgba(255,255,255,.12);
        background: rgba(255,255,255,.06);
        color: rgba(255,255,255,.9);
        cursor:pointer;
    }

    .card{
        background: rgba(255,255,255,.04);
        border: 1px solid rgba(255,255,255,.10);
        border-radius: 16px;
        padding: 12px;
    }
    .name{ font-size: 18px; font-weight: 900; }
    .meta{ margin-top: 8px; display:flex; gap: 8px; flex-wrap:wrap; }
    .chip{
        font-size: 12px;
        padding: 6px 8px;
        border-radius: 999px;
        border: 1px solid rgba(255,255,255,.10);
        background: rgba(0,0,0,.12);
    }
    .muted{ color: rgba(255,255,255,.62); }


    .actions{ margin-top: 12px; display:flex; gap: 10px; }
    .btn{
        flex:1;
        padding: 12px 12px;
        border-radius: 14px;
        border: 1px solid rgba(255,255,255,.12);
        background: rgba(46,243,255,.10);
        color: rgba(255,255,255,.92);
        cursor:pointer;
    }
</style>