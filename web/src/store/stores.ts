import { writable } from "svelte/store";
export const profilesQuery = writable<string>("");
export const profilesResults = writable<Profile[]>([]);

export const vehiclesQuery = writable<string>("");
export const vehiclesResults = writable<Vehicle[]>([]);


export type DashboardData = {
    counters: { incidents: number; open: number; investigation: number };
    recents: Array<{ id: number; title: string; type: string; date: string }>;
};

export type Profile = {
    citizenid: string;
    firstname: string;
    lastname: string;
    dob?: string;
    phone?: string;
    job?: string;
};

export type Vehicle = {
    plate: string;
    model?: string;
    owner?: string;
    state?: string;
};

export const dashboard = writable<DashboardData>({
    counters: { incidents: 0, open: 0, investigation: 0 },
    recents: [],
});

export const profiles = writable<Profile[]>([]);
export const vehicles = writable<Vehicle[]>([]);
export const loading = writable<{ [key: string]: boolean }>({});
/** Returns boolean value of if the resource is visible or not */
export const visibility = writable(false);
