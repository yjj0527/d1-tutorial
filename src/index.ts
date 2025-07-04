export interface Env {
	// If you set another name in wrangler.toml as the value for 'binding',
	// replace "DB" with the variable name you defined.
	DB: D1Database;
}

export default {
	async fetch(request, env): Promise<Response> {
		const { pathname } = new URL(request.url);

		if (pathname === '/api/properties') {
			const propertiesQuery = `
        SELECT
          p.ID,
          p.Name,
          p.PricePerCalenderMonth,
          p.Furnished,
          p.Bedrooms,
          COALESCE(likes_dislikes.Likes, 0) AS Likes,
          COALESCE(likes_dislikes.Dislikes, 0) AS Dislikes,
          COALESCE(images.Images, '') AS Images
        FROM Properties p
        LEFT JOIN (
          SELECT
            PropertyID,
            COUNT(CASE WHEN IsLike = 1 THEN 1 END) AS Likes,
            COUNT(CASE WHEN IsLike = 0 THEN 1 END) AS Dislikes
          FROM LikesDislikes
          GROUP BY PropertyID
        ) likes_dislikes ON p.ID = likes_dislikes.PropertyID
        LEFT JOIN (
          SELECT
            PropertyID,
            GROUP_CONCAT(ImageURL) AS Images
          FROM Images
          GROUP BY PropertyID
        ) images ON p.ID = images.PropertyID
      `;
			const propertiesResult = await env.DB.prepare(propertiesQuery).all();
			const properties = propertiesResult.results.map((property: any) => ({
				...property,
				Images: property.Images ? property.Images.split(',') : [],
			}));

			return Response.json(properties);
		}

		if (pathname.startsWith('/api/properties/')) {
			const id = pathname.split('/').pop();
			const propertyQuery = `
			  SELECT
				p.ID,
				p.Name,
				p.Description,
				p.PricePerCalenderMonth,
				p.Furnished,
				p.Bedrooms,
				COALESCE(ld.Likes, 0) AS Likes,
				COALESCE(ld.Dislikes, 0) AS Dislikes,
				COALESCE(img.Images, '') AS Images,
				COALESCE(amn.Amenities, '') AS Amenities
			  FROM Properties p
			  LEFT JOIN (
				SELECT
				  PropertyID,
				  COUNT(CASE WHEN IsLike = 1 THEN 1 END) AS Likes,
				  COUNT(CASE WHEN IsLike = 0 THEN 1 END) AS Dislikes
				FROM LikesDislikes
				GROUP BY PropertyID
			  ) ld ON p.ID = ld.PropertyID
			  LEFT JOIN (
				SELECT
				  PropertyID,
				  GROUP_CONCAT(ImageURL) AS Images
				FROM Images
				GROUP BY PropertyID
			  ) img ON p.ID = img.PropertyID
			  LEFT JOIN (
				SELECT
				  pa.PropertyID,
				  GROUP_CONCAT(a.Name) AS Amenities
				FROM PropertyAmenities pa
				INNER JOIN Amenities a ON pa.AmenityID = a.ID
				GROUP BY pa.PropertyID
			  ) amn ON p.ID = amn.PropertyID
			  WHERE p.ID = ?
			`;
			const propertyResult = await env.DB.prepare(propertyQuery).bind(id).first();

			if (!propertyResult) {
				return new Response('Property not found', { status: 404 });
			}

			const property = {
				...propertyResult,
				Images: propertyResult.Images ? propertyResult.Images.split(',') : [],
				Amenities: propertyResult.Amenities ? propertyResult.Amenities.split(',') : [],
			};

			return Response.json(property);
		}

		return new Response('Call /api/properties to see the list of Properties');
	},
} satisfies ExportedHandler<Env>;
