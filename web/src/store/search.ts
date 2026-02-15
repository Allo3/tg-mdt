import { fetchNui } from "../utils/fetchNui";
import { createSearchStore } from "../utils/createSearchStore";
import type { Profile, Vehicle } from "./stores";

function normalizeArray<T>(resp: any): T[] {
    if (Array.isArray(resp)) return resp;
    if (resp && Array.isArray(resp.data)) return resp.data;
    return [];
}

export const profilesSearch = createSearchStore<Profile>(
    function (q) {
        return fetchNui("searchProfiles", { query: q });
    },
    function (resp) {
        return normalizeArray<Profile>(resp);
    },
    { minLength: 1, keepResultsOnEmpty: true, debounceMs: 200 }
);

export const vehiclesSearch = createSearchStore<Vehicle>(
    function (q) {
        return fetchNui("searchVehicles", { query: q });
    },
    function (resp) {
        return normalizeArray<Vehicle>(resp);
    },
    { minLength: 1, keepResultsOnEmpty: true, debounceMs: 200 }
);