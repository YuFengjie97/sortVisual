import NotFound from "./views/NotFound.vue";

/** @type {import('vue-router').RouterOptions['routes']} */
export const routes = [
  {
    path: "/",
    component: () => import("./views/BubbleSort/index.vue"),
    meta: { title: "排序可视化" },
  },
  {
    path: "/test",
    component: () => import("./views/Test/index.vue"),
    meta: { title: "test" },
  },
  {
    path: "/:path(.*)",
    component: NotFound,
  },
];
