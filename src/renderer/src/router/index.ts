import { createRouter, createWebHashHistory } from 'vue-router';
import IconManager from '../components/IconManager.vue';
import svgPreview from '../components/svgPreview.vue';

const routes = [
  { path: '/', component: IconManager },
  { path: '/icon-manager', component: IconManager },
  { path: '/svg-preview', component: svgPreview },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;