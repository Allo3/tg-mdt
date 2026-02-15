import * as S from "svelte/store";

const { get, writable } = S;
type Writable<T> = S.Writable<T>;

type Normalize<T> = (resp: any) => T[];
type Fetcher = (query: string) => Promise<any>;

export type SearchStore<T> = {
    query: Writable<string>;
    results: Writable<T[]>;
    loading: Writable<boolean>;
    error: Writable<string | null>;
    search: (q?: string) => Promise<void>;
    onInput: (q: string, debounceMs?: number) => void;
    clear: () => void;
};

export function createSearchStore<T>(
    fetcher: Fetcher,
    normalize: Normalize<T>,
    opts?: { minLength?: number; keepResultsOnEmpty?: boolean; debounceMs?: number }
): SearchStore<T> {
    const query = writable<string>("");
    const results = writable<T[]>([]);
    const loading = writable<boolean>(false);
    const error = writable<string | null>(null);

    let timer: ReturnType<typeof setTimeout> | null = null;
    let token = 0;

    const minLength =
        opts && typeof opts.minLength === "number" ? opts.minLength : 1;
    const keepResultsOnEmpty =
        opts && typeof opts.keepResultsOnEmpty === "boolean"
            ? opts.keepResultsOnEmpty
            : true;
    const defaultDebounce =
        opts && typeof opts.debounceMs === "number" ? opts.debounceMs : 200;

    async function search(q?: string) {
        const qFinal = String(q != null ? q : get(query)).trim();
        query.set(qFinal);

        if (qFinal.length < minLength) {
            loading.set(false);
            error.set(null);
            if (!keepResultsOnEmpty) results.set([]);
            return;
        }

        const myToken = ++token;
        loading.set(true);
        error.set(null);

        try {
            const resp = await fetcher(qFinal);
            if (myToken !== token) return;
            results.set(normalize(resp));
        } catch {
            if (myToken !== token) return;
            error.set("Erreur de recherche (NUI)");
        } finally {
            if (myToken === token) loading.set(false);
        }
    }

    function onInput(q: string, debounceMs?: number) {
        query.set(q);
        if (timer) clearTimeout(timer);

        const qTrim = String(q).trim();
        if (qTrim.length < minLength) {
            loading.set(false);
            error.set(null);
            if (!keepResultsOnEmpty) results.set([]);
            return;
        }

        const ms = typeof debounceMs === "number" ? debounceMs : defaultDebounce;
        timer = setTimeout(() => search(qTrim), ms);
    }

    function clear() {
        query.set("");
        results.set([]);
        loading.set(false);
        error.set(null);
    }

    return { query, results, loading, error, search, onInput, clear };
}