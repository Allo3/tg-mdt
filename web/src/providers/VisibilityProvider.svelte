<script lang="ts">
  import { useNuiEvent } from '../utils/useNuiEvent';
  import { fetchNui } from '../utils/fetchNui';
  import { onMount } from 'svelte';
  import { visibility } from '../store/stores';

  // Svelte store auto-subscription via $visibility
  $: isVisible = $visibility;

  useNuiEvent<boolean>('setVisible', (visible) => {
    visibility.set(visible);
  });

  onMount(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (isVisible && ['Escape'].includes(e.code)) {
        fetchNui('hideUI');
        visibility.set(false);
      }
    };

    window.addEventListener('keydown', keyHandler);

    return () => window.removeEventListener('keydown', keyHandler);
  });
</script>

<!-- Keep DOM mounted so we can animate visibility safely (no "black screen" leftovers) -->
{#if isVisible}
  <slot />
{/if}
