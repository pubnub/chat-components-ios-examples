import { router } from '../utils/router'

export const name = 'loadTestRouter'

export default router(expect, {
  'GET /time/:param': (req, params) => {
    console.log(req.url.path)

    return {
      status: 200,
      body: {
        result: params.param,
      },
    }
  },
})
